locals {
  nomad_apps_clients = [
    for i in range(1, var.nomad_apps_clients_qtd + 1) :
    "nomad-apps-client-${i}"
  ]

  nomad_clients = concat(keys(local.nomad_infra_clients), local.nomad_apps_clients)
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
  for_each = toset(local.nomad_clients)

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
          docker    = local.cloudinit_apt_docker
          getenvoy  = local.cloudinit_apt_getenvoy
        }
      }
      packages = [
        "openssh-server",
        "consul",
        "nomad",
        "docker-ce",
        "containerd.io",
        "getenvoy-envoy",
        "nfs-common",
      ]
      runcmd = [
        "mkdir -p /opt/cni/bin",
        "wget -q -O /tmp/cni-plugins.tgz https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz",
        "tar -vxf /tmp/cni-plugins.tgz -C /opt/cni/bin",
        "chown root.root /opt/cni/bin",
        "chmod 755 /opt/cni/bin/*",
        "rm /tmp/cni-plugins.tgz",
        "usermod -aG docker nomad",
        "systemctl enable consul nomad docker",
        "systemctl start consul nomad docker",
        "systemctl restart systemd-resolved",
        "docker plugin install grafana/loki-docker-driver:2.9.3 --alias loki --grant-all-permissions",
        "mount --make-shared /",
      ]
      write_files = [
        local.cloudinit_consul_dns,
        { path = "/etc/certs.d/ca.pem", content = tls_self_signed_cert.nomad_cluster.cert_pem },
        { path = "/etc/certs.d/cert.pem", content = tls_locally_signed_cert.nomad_client.cert_pem },
        { path = "/etc/certs.d/key.pem", content = tls_private_key.nomad_client.private_key_pem },
        {
          path    = "/etc/systemd/resolved.conf.d/docker.conf",
          content = <<-EOT
            [Resolve]
            DNSStubListener=yes
            DNSStubListenerExtra=172.17.0.1
          EOT
        },
        {
          path    = "/etc/docker/daemon.json",
          content = <<-EOT
            {
              "dns": ["172.17.0.1"],
              "registry-mirrors": [
                "http://docker-hub-mirror.service.consul:5000"
              ]
            }
          EOT
        },
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
      ]
    })
  }
}

resource "lxd_instance" "nomad_client" {
  for_each = merge(local.nomad_infra_clients, { for i in local.nomad_apps_clients : i => null })

  name     = each.key
  image    = var.ubuntu_image
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
    "cloud-init.user-data" = data.cloudinit_config.nomad_client[each.key].rendered
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
