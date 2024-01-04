locals {
  nomad_apps_clients = [
    for i in range(1, var.nomad_apps_clients_qtd + 1) :
    "nomad-apps-client-${i}"
  ]

  nomad_clients = concat(keys(local.nomad_infra_clients), local.nomad_apps_clients)

  nomad_node_pool = merge(
    { for s, _ in local.nomad_infra_clients : s => "infra" },
    { for s in local.nomad_apps_clients : s => "default" },
  )
}

resource "consul_acl_token" "nomad_client_agent" {
  for_each = toset(local.nomad_clients)

  node_identities {
    datacenter = "dc1"
    node_name  = each.key
  }
}

data "consul_acl_token_secret_id" "nomad_client_agent" {
  for_each = toset(local.nomad_clients)

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
  EOT
}

resource "consul_acl_token" "nomad_client" {
  depends_on = [null_resource.ansible_consul]
  for_each   = toset(local.nomad_clients)

  description = "${each.key} client token"
  policies    = [consul_acl_policy.nomad_client.name]
}

data "consul_acl_token_secret_id" "nomad_client" {
  for_each = toset(local.nomad_clients)

  accessor_id = consul_acl_token.nomad_client[each.key].id
}

data "cloudinit_config" "nomad_client" {
  for_each = toset(local.nomad_clients)

  gzip          = false
  base64_encode = false

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = yamlencode({
      ssh_authorized_keys = [tls_private_key.ssh_nomad_cluster.public_key_openssh]
      runcmd = [
        "systemctl restart consul nomad",
      ]
      write_files = [
        { path = "/etc/certs.d/ca.pem", content = tls_self_signed_cert.nomad_cluster.cert_pem },
        { path = "/etc/certs.d/cert.pem", content = tls_locally_signed_cert.nomad_client.cert_pem },
        { path = "/etc/certs.d/key.pem", content = tls_private_key.nomad_client.private_key_pem },
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
              node_pool    = local.nomad_node_pool[each.key]
              consul_token = data.consul_acl_token_secret_id.nomad_client[each.key].secret_id
            }
          )
        },
      ]
    })
  }
}

resource "lxd_instance" "nomad_client" {
  for_each = merge(local.nomad_infra_clients, { for i in local.nomad_apps_clients : i => null })
  depends_on = [packer_image.nomad_client]

  name     = each.key
  image    = "local:nomad-client"
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
      private_key = data.tls_public_key.ssh_nomad_cluster.private_key_openssh
    }
  
    inline = ["cloud-init status -w > /dev/null"]
  }
}
