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
  EOT
}

resource "consul_acl_token" "nomad_server" {
  depends_on = [null_resource.ansible_consul]
  for_each   = local.nomad_servers

  description = "${each.key} client token"
  policies    = [consul_acl_policy.nomad_server.name]
}

data "consul_acl_token_secret_id" "nomad_server" {
  for_each = local.nomad_servers

  accessor_id = consul_acl_token.nomad_server[each.key].id
}

# Vault integration
resource "vault_policy" "nomad_server" {
  depends_on = [null_resource.ansible_vault]

  name = "nomad-server"

  policy = <<-EOT
    # Allow creating tokens under "nomad-cluster" token role. The token role name
    # should be updated if "nomad-cluster" is not used.
    path "auth/token/create/nomad-cluster" {
      capabilities = ["update"]
    }

    # Allow looking up "nomad-cluster" token role. The token role name should be
    # updated if "nomad-cluster" is not used.
    path "auth/token/roles/nomad-cluster" {
      capabilities = ["read"]
    }

    # Allow looking up the token passed to Nomad to validate # the token has the
    # proper capabilities. This is provided by the "default" policy.
    path "auth/token/lookup-self" {
      capabilities = ["read"]
    }

    # Allow looking up incoming tokens to validate they have permissions to access
    # the tokens they are requesting. This is only required if
    # `allow_unauthenticated` is set to false.
    path "auth/token/lookup" {
      capabilities = ["update"]
    }

    # Allow revoking tokens that should no longer exist. This allows revoking
    # tokens for dead tasks.
    path "auth/token/revoke-accessor" {
      capabilities = ["update"]
    }

    # Allow checking the capabilities of our own token. This is used to validate the
    # token upon startup. Note this requires update permissions because the Vault API
    # is a POST
    path "sys/capabilities-self" {
      capabilities = ["update"]
    }

    # Allow our own token to be renewed.
    path "auth/token/renew-self" {
      capabilities = ["update"]
    }
  EOT
}

resource "vault_token_auth_backend_role" "nomad_cluster" {
  depends_on = [null_resource.ansible_vault]

  role_name              = "nomad-cluster"
  disallowed_policies    = ["nomad-server"]
  token_explicit_max_ttl = 0
  orphan                 = true
  token_period           = 259200
  renewable              = true
}

resource "vault_token" "nomad_server" {
  policies  = [vault_policy.nomad_server.name]
  period    = "72h"
  no_parent = true
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
          hashicorp = {
            source = "deb [arch=amd64 signed-by=$KEY_FILE] https://apt.releases.hashicorp.com ${var.ubuntu_version} main"
            key    = data.http.hashicorp_gpg.response_body
          }
        }
      }
      packages = ["openssh-server", "consul", "nomad"]
      runcmd = [
        "systemctl enable consul nomad",
        "systemctl start consul nomad",
        "systemctl restart systemd-resolved",
      ]
      write_files = [
        { path = "/etc/certs.d/ca.pem", content = tls_self_signed_cert.nomad_cluster.cert_pem },
        { path = "/etc/certs.d/cert.pem", content = tls_locally_signed_cert.nomad_server.cert_pem },
        { path = "/etc/certs.d/key.pem", content = tls_private_key.nomad_server.private_key_pem },
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
              agent_token    = data.consul_acl_token_secret_id.nomad_server_agent[each.key].secret_id
            }
          )
        },
        {
          path = "/etc/nomad.d/nomad.hcl", content = templatefile(
            "cloud-init/nomad-server.hcl", {
              encrypt_key  = random_id.nomad_encrypt_key.b64_std
              consul_token = data.consul_acl_token_secret_id.nomad_server[each.key].secret_id
              vault_token  = vault_token.nomad_server.client_token
            }
          )
        },
      ]
    })
  }
}

resource "lxd_instance" "nomad_server" {
  depends_on = [ lxd_instance.consul_server ]
  for_each = local.nomad_servers

  name     = each.key
  image    = var.ubuntu_image
  profiles = ["default", lxd_profile.nomad.name]

  config = {
    "cloud-init.user-data" = data.cloudinit_config.nomad_server[each.key].rendered
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

resource "ansible_group" "nomad_servers" {
  name = "nomad_servers"
}

resource "ansible_host" "nomad_server" {
  for_each = local.nomad_servers

  name   = each.key
  groups = [ansible_group.nomad_servers.name]

  variables = {
    ansible_host = each.value
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
  filename   = ".tmp/ansible/root_token_nomad.txt"
}
