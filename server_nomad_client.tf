data "packer_files" "nomad_client" {
  file = "./packer/nomad-client.pkr.hcl"
  file_dependencies = [
    "./packer/provision-nomad-client.sh"
  ]
}

resource "packer_image" "nomad_client" {
  name      = "nomad-client"
  directory = "./packer"
  file      = "nomad-client.pkr.hcl"
  force     = true

  triggers = {
    nomad_client = data.packer_files.nomad_client.files_hash
  }

  provisioner "local-exec" {
    when    = destroy
    command = "lxc image delete ${self.name}"
  }
}

locals {
  nomad_clients = merge(local.nomad_infra_clients, local.nomad_apps_clients)

  docker_daemon_json = <<-EOT
    {
      "registry-mirrors": [
        "http://docker-hub-mirror.service.consul:5000"
      ]
    }
  EOT
}

resource "consul_acl_token" "nomad_client_agent" {
  for_each = local.nomad_clients

  node_identities {
    datacenter = "dc1"
    node_name  = each.key
  }
}

data "consul_acl_token_secret_id" "nomad_client_agent" {
  for_each = local.nomad_clients

  accessor_id = consul_acl_token.nomad_client_agent[each.key].id
}

resource "consul_acl_policy" "nomad_client" {
  name  = "nomad-client"
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

    key_prefix "" {
      policy = "read"
    }

    mesh = "write"
  EOT
}

resource "consul_acl_token" "nomad_client" {
  depends_on = [null_resource.ansible_consul]

  description = "Nomad client token"
  policies    = [consul_acl_policy.nomad_client.name]
}

data "consul_acl_token_secret_id" "nomad_client" {
  accessor_id = consul_acl_token.nomad_client.id
}

data "cloudinit_config" "nomad_client" {
  for_each = local.nomad_clients

  gzip          = false
  base64_encode = false

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = yamlencode({
      ssh_authorized_keys = [tls_private_key.ssh_nomad_cluster.public_key_openssh]
      packages = [
        "openssh-server",
      ],
      write_files = [
        { path = "/etc/certs.d/ca.pem", content = tls_self_signed_cert.nomad_cluster.cert_pem },
        { path = "/etc/certs.d/cert.pem", content = tls_locally_signed_cert.nomad_client.cert_pem },
        { path = "/etc/certs.d/key.pem", content = tls_private_key.nomad_client.private_key_pem },
        { path = "/etc/docker/daemon.json", content = local.docker_daemon_json },
        {
          path = "/etc/consul.d/consul.hcl", content = templatefile(
            "config/consul-client.hcl", {
              consul_servers    = values(lxd_instance.consul_server)[*].ipv4_address
              encrypt_key       = random_id.consul_encrypt_key.b64_std
              agent_token       = data.consul_acl_token_secret_id.nomad_client_agent[each.key].secret_id
              network_interface = "enp5s0"
            }
          )
        },
        {
          path = "/etc/nomad.d/nomad.hcl", content = templatefile(
            "config/nomad-client.hcl", {
              node_pool    = startswith(each.key, "nomad-infra-client-") ? "infra" : "default",
              consul_token = data.consul_acl_token_secret_id.nomad_client.secret_id
            }
          )
        },
      ],
      runcmd = [
        "systemctl restart docker",
        "systemctl start consul",
        "systemctl start nomad",
      ],
    })
  }
}

resource "lxd_instance" "nomad_client" {
  for_each   = local.nomad_clients
  depends_on = [lxd_instance.nomad_server]

  name     = each.key
  image    = packer_image.nomad_client.name
  type     = "virtual-machine"
  profiles = [lxd_profile.nomad_cluster.name]

  limits = {
    cpu    = 2
    memory = startswith(each.key, "nomad-infra-client-") ? "3GB" : "2GB"
  }

  device {
    name = "enp5s0"
    type = "nic"

    properties = {
      network        = lxd_network.nomad.name
      "ipv4.address" = each.value
    }
  }

  config = {
    "cloud-init.user-data"  = data.cloudinit_config.nomad_client[each.key].rendered
    "user.access_interface" = "enp5s0"
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
