resource "random_id" "nomad_encrypt_key" {
  byte_length = 32
}

# Consul integration
resource "consul_acl_token" "nomad_server_agent" {
  depends_on = [null_resource.ansible_consul]
  for_each   = local.nomad_servers

  accessor_id = uuidv5("dns", "${each.key}.agent.consul")
  description = "${each.key} consul agent token"

  node_identities {
    datacenter = "dc1"
    node_name  = each.key
  }
}

data "consul_acl_token_secret_id" "nomad_server_agent" {
  for_each = local.nomad_servers

  accessor_id = consul_acl_token.nomad_server_agent[each.key].id
}

resource "consul_acl_policy" "nomad_server" {
  name  = "nomad-server"
  rules = <<-EOT
    agent_prefix "" {
      policy = "read"
    }

    node_prefix "" {
      policy = "read"
    }

    service_prefix "" {
      policy = "write"
    }

    acl = "write"
    mesh = "write"
  EOT
}

resource "consul_acl_token" "nomad_server" {
  depends_on = [null_resource.ansible_consul]

  description = "Nomad server token"
  policies    = [consul_acl_policy.nomad_server.name]
}

data "consul_acl_token_secret_id" "nomad_server" {
  accessor_id = consul_acl_token.nomad_server.id
}

data "cloudinit_config" "nomad_server" {
  for_each = local.nomad_servers

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
      packages = ["openssh-server", "consul", "nomad"]
      write_files = [
        local.cloudinit_consul_dns,
        { path = "/etc/certs.d/ca.pem", content = tls_self_signed_cert.nomad_cluster.cert_pem },
        { path = "/etc/certs.d/cert.pem", content = tls_locally_signed_cert.nomad_server.cert_pem },
        { path = "/etc/certs.d/key.pem", content = tls_private_key.nomad_server.private_key_pem },
        {
          path = "/etc/consul.d/consul.hcl", content = templatefile(
            "config/consul-client.hcl", {
              consul_servers    = values(lxd_instance.consul_server)[*].ipv4_address
              encrypt_key       = random_id.consul_encrypt_key.b64_std
              agent_token       = data.consul_acl_token_secret_id.nomad_server_agent[each.key].secret_id
              network_interface = "eth0"
            }
          )
        },
        {
          path = "/etc/nomad.d/nomad.hcl", content = templatefile(
            "config/nomad-server.hcl", {
              encrypt_key  = random_id.nomad_encrypt_key.b64_std
              consul_token = data.consul_acl_token_secret_id.nomad_server.secret_id
            }
          )
        },
      ]
      runcmd = [
        "mkdir -p /opt/nomad/data && chown -R nomad:nomad /opt/nomad",
        "sed -i '/\\[Service\\]/a User=nomad' /usr/lib/systemd/system/nomad.service",
        "systemctl daemon-reload",
        "systemctl enable consul nomad",
        "systemctl start consul nomad",
        "systemctl restart systemd-resolved",
        "ln -s /etc/certs.d/ca.pem /usr/local/share/ca-certificates/nomad-cluster.crt",
        "update-ca-certificates",
        "if [ '${var.external_domain}' = 'localhost' ]; then echo '${local.load_balancer["host"]} vault.${var.external_domain}' >> /etc/hosts; fi",
        "if [ '${var.external_domain}' = 'localhost' ]; then echo '${local.load_balancer["host"]} keycloak.${var.apps_subdomain}.${var.external_domain}' >> /etc/hosts; fi",
      ]
    })
  }
}

resource "lxd_volume" "nomad_server_data" {
  for_each = toset(keys(local.nomad_servers))

  name         = "${each.key}-data"
  pool         = lxd_storage_pool.nomad_cluster.name
  content_type = "filesystem"
}

resource "lxd_instance" "nomad_server" {
  for_each = local.nomad_servers

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
    name = "nomad-data"
    type = "disk"
    properties = {
      path   = "/opt/nomad/data"
      source = lxd_volume.nomad_server_data[each.key].name
      pool   = lxd_volume.nomad_server_data[each.key].pool
    }
  }

  config = {
    "cloud-init.user-data" = data.cloudinit_config.nomad_server[each.key].rendered
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

resource "null_resource" "ansible_nomad_server" {
  depends_on = [
    lxd_instance.nomad_server,
    null_resource.setup_ansible,
    ansible_group.nomad_servers,
    ansible_host.nomad_server,
  ]

  provisioner "local-exec" {
    command = ".venv/bin/ansible-playbook ansible/playbook-nomad.yml"
  }
}

data "local_sensitive_file" "nomad_root_token" {
  depends_on = [null_resource.ansible_nomad_server]
  filename   = ".tmp/root_token_nomad.txt"
}
