resource "random_id" "consul_encrypt_key" {
  byte_length = 32
}

data "cloudinit_config" "consul_server" {
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
      packages = ["openssh-server", "consul"]
      runcmd = [
        "systemctl enable consul",
        "systemctl start consul",
      ]
      write_files = [
        { path = "/etc/certs.d/ca.pem", content = tls_self_signed_cert.nomad_cluster.cert_pem },
        { path = "/etc/certs.d/cert.pem", content = tls_locally_signed_cert.consul.cert_pem },
        { path = "/etc/certs.d/key.pem", content = tls_private_key.consul.private_key_pem },
        {
          path = "/etc/consul.d/consul.hcl", content = templatefile(
            "config/consul-server.hcl", {
              consul_servers = values(local.consul_servers)
              encrypt_key    = random_id.consul_encrypt_key.b64_std
            }
          )
        },
      ]
    })
  }
}

resource "lxd_instance" "consul_server" {
  for_each = local.consul_servers

  name     = each.key
  image    = var.ubuntu_image

  device {
    name = "eth0"
    type = "nic"

    properties = {
      network = lxd_network.nomad.name
      "ipv4.address" = each.value
    }
  }

  config = {
    "cloud-init.user-data" = data.cloudinit_config.consul_server.rendered
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

resource "null_resource" "ansible_consul" {
  depends_on = [
    lxd_instance.consul_server,
    null_resource.setup_ansible,
    ansible_group.consul_servers,
    ansible_host.consul_server,
  ]

  provisioner "local-exec" {
    command = ".venv/bin/ansible-playbook ansible/playbook-consul.yml"
  }
}

data "local_sensitive_file" "consul_root_token" {
  depends_on = [null_resource.ansible_consul]
  filename   = ".tmp/root_token_consul.txt"
}

resource "consul_acl_token" "consul_server" {
  for_each = local.consul_servers

  description = "${each.key} agent token"

  node_identities {
    datacenter = "dc1"
    node_name  = each.key
  }
}

data "consul_acl_token_secret_id" "consul_server" {
  for_each = local.consul_servers

  accessor_id = consul_acl_token.consul_server[each.key].accessor_id
}

resource "null_resource" "consul_server_agent_token" {
  for_each = lxd_instance.consul_server

  provisioner "remote-exec" {
    connection {
      host        = each.value.ipv4_address
      user        = "ubuntu"
      private_key = data.tls_public_key.ssh_nomad_cluster.private_key_openssh
    }

    inline = [
      "consul acl set-agent-token -token ${data.local_sensitive_file.consul_root_token.content} agent ${data.consul_acl_token_secret_id.consul_server[each.key].secret_id}"
    ]
  }
}

resource "consul_acl_policy" "anonymous_dns" {
  name  = "anonymous-dns"
  rules = <<-EOT
    # allow access to metrics
    agent_prefix "consul-server-" {
      policy = "read"
    }

    # allow dns queries
    node_prefix "" {
      policy = "read"
    }

    service_prefix "" {
      policy = "read"
  }
  EOT
}

resource "consul_acl_token_policy_attachment" "anonymous_dns" {
  # anonymous token
  token_id = "00000000-0000-0000-0000-000000000002"
  policy   = consul_acl_policy.anonymous_dns.name
}
