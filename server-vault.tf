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
  for_each   = local.vault_servers

  description = "${each.key} client token"
  policies    = [consul_acl_policy.vault_server.name]
}

data "consul_acl_token_secret_id" "vault_server" {
  for_each = local.vault_servers

  accessor_id = consul_acl_token.vault_server[each.key].id
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
          hashicorp = {
            source = "deb [arch=amd64 signed-by=$KEY_FILE] https://apt.releases.hashicorp.com ${var.ubuntu_version} main"
            key    = data.http.hashicorp_gpg.response_body
          }
        }
      }
      packages = ["openssh-server", "consul", "vault"]
      runcmd = [
        "systemctl enable consul vault",
        "systemctl start consul vault",
        "systemctl restart systemd-resolved",
      ]
      write_files = [
        { path = "/etc/certs.d/ca.pem", content = tls_self_signed_cert.nomad_cluster.cert_pem },
        { path = "/etc/certs.d/cert.pem", content = tls_locally_signed_cert.vault.cert_pem },
        { path = "/etc/certs.d/key.pem", content = tls_private_key.vault.private_key_pem },
        {
          path    = "/etc/systemd/resolved.conf.d/consul.conf",
          content = <<-EOT
            [Resolve]
            DNS=127.0.0.1:8600
            DNSSEC=false
            Domains=~consul
          EOT
        },
        {
          path = "/etc/consul.d/consul.hcl", content = templatefile(
            "cloud-init/consul-client.hcl", {
              consul_servers = values(local.consul_servers)
              encrypt_key    = random_id.consul_encrypt_key.b64_std
              agent_token    = data.consul_acl_token_secret_id.vault_server_agent[each.key].secret_id
            }
          )
        },
        {
          path = "/etc/vault.d/vault.hcl", content = templatefile(
            "cloud-init/vault.hcl", {
              hostname      = each.key
              vault_servers = local.vault_servers
              consul_token  = data.consul_acl_token_secret_id.vault_server[each.key].secret_id
            }
          )
        },
      ]
    })
  }
}

resource "lxd_instance" "vault_server" {
  for_each = local.vault_servers

  name     = each.key
  image    = var.ubuntu_image
  profiles = ["default", lxd_profile.nomad.name]

  config = {
    "cloud-init.user-data" = data.cloudinit_config.vault_server[each.key].rendered
    "cloud-init.network-config" = yamlencode({
      version = 2
      ethernets = {
        eth0 = {
          addresses   = ["${each.value}/16"]
          routes      = [{ to = "default", via = local.gateway_address }]
          nameservers = { addresses = ["9.9.9.9", "149.112.112.112"] }
        }
      }
    })
  }

  provisioner "remote-exec" {
    connection {
      host        = self.ipv4_address
      user        = "ubuntu"
      private_key = data.tls_public_key.ssh_nomad_cluster.private_key_openssh
    }
    inline = ["cloud-init status -w > /dev/null"]
  }
}

resource "ansible_group" "vault_servers" {
  name = "vault_servers"
}

resource "ansible_host" "vault_server" {
  for_each = local.vault_servers

  name   = each.key
  groups = [ansible_group.vault_servers.name]

  variables = {
    ansible_host = each.value
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
  filename   = ".tmp/ansible/root_token_vault.txt"
}
