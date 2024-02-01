resource "consul_acl_token" "vault_server_agent" {
  depends_on = [null_resource.ansible_consul]
  for_each   = local.vault_servers

  accessor_id = uuidv5("dns", "${each.key}.agent.consul")
  description = "${each.key} consul agent token"

  node_identities {
    datacenter = "dc1"
    node_name  = each.key
  }
}

data "consul_acl_token_secret_id" "vault_server_agent" {
  for_each = local.vault_servers

  accessor_id = consul_acl_token.vault_server_agent[each.key].id
}

resource "consul_acl_policy" "vault_server" {
  name  = "vault-server"
  rules = <<-EOT
    service "vault" {
      policy = "write"
    }
  EOT
}

resource "consul_acl_token" "vault_server" {
  depends_on = [null_resource.ansible_consul]

  description = "Vault token"
  policies    = [consul_acl_policy.vault_server.name]
}

data "consul_acl_token_secret_id" "vault_server" {
  accessor_id = consul_acl_token.vault_server.id
}

data "cloudinit_config" "vault_server" {
  for_each = local.vault_servers

  gzip          = false
  base64_encode = false

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = yamlencode({
      ssh_authorized_keys = [tls_private_key.ssh_nomad_cluster.public_key_openssh]
      apt = {
        sources = {
          hashicorp = local.cloudinit_apt_hashicorp
        }
      }
      packages = ["openssh-server", "consul", "vault"]
      write_files = [
        local.cloudinit_consul_dns,
        { path = "/etc/certs.d/ca.pem", content = tls_self_signed_cert.nomad_cluster.cert_pem },
        { path = "/etc/certs.d/cert.pem", content = tls_locally_signed_cert.vault.cert_pem },
        { path = "/etc/certs.d/key.pem", content = tls_private_key.vault.private_key_pem },
        {
          path = "/etc/consul.d/consul.hcl", content = templatefile(
            "config/consul-client.hcl", {
              consul_servers    = values(lxd_instance.consul_server)[*].ipv4_address
              encrypt_key       = random_id.consul_encrypt_key.b64_std
              agent_token       = data.consul_acl_token_secret_id.vault_server_agent[each.key].secret_id
              network_interface = "eth0"
            }
          )
        },
        {
          path = "/etc/vault.d/vault.hcl", content = templatefile(
            "config/vault.hcl", {
              hostname      = each.key
              vault_servers = local.vault_servers
              consul_token  = data.consul_acl_token_secret_id.vault_server.secret_id
            }
          )
        },
      ]
      runcmd = [
        "systemctl enable consul vault",
        "systemctl start consul vault",
        "systemctl restart systemd-resolved",
        "if [ '${var.external_domain}' = 'localhost' ]; then echo '${local.load_balancer["host"]} nomad.${var.external_domain}' >> /etc/hosts; fi",
      ]
    })
  }
}

resource "lxd_volume" "vault_server_data" {
  for_each = toset(keys(local.vault_servers))

  name         = "${each.key}-data"
  pool         = lxd_storage_pool.nomad_cluster.name
  content_type = "filesystem"
}

resource "lxd_instance" "vault_server" {
  for_each = local.vault_servers

  name     = each.key
  image    = "ubuntu:${var.ubuntu_version}"
  profiles = [lxd_profile.nomad_cluster.name]

  device {
    name = "eth0"
    type = "nic"

    properties = {
      network        = lxd_network.nomad.name
      "ipv4.address" = each.value
    }
  }

  device {
    name = "vault-data"
    type = "disk"
    properties = {
      path   = "/opt/vault/data"
      source = lxd_volume.vault_server_data[each.key].name
      pool   = lxd_volume.vault_server_data[each.key].pool
    }
  }

  config = {
    "cloud-init.user-data" = data.cloudinit_config.vault_server[each.key].rendered
  }

  provisioner "remote-exec" {
    connection {
      host        = self.ipv4_address
      user        = "ubuntu"
      private_key = tls_private_key.ssh_nomad_cluster.private_key_openssh
    }
    inline = ["cloud-init status -w > /dev/null"]
  }
}

resource "null_resource" "ansible_vault" {
  depends_on = [
    lxd_instance.vault_server,
    null_resource.setup_ansible,
    ansible_group.vault_servers,
    ansible_host.vault_server,
  ]

  provisioner "local-exec" {
    command = ".venv/bin/ansible-playbook ansible/playbook-vault.yml"
  }
}

data "local_sensitive_file" "vault_root_token" {
  depends_on = [null_resource.ansible_vault]
  filename   = ".tmp/root_token_vault.txt"
}
