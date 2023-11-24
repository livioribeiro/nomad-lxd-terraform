data "cloudinit_config" "load_balancer" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = yamlencode({
      ssh_authorized_keys = [tls_private_key.ssh_nomad_cluster.public_key_openssh]
      packages            = ["openssh-server", "haproxy"]
      write_files = [
        { path = "/etc/certs.d/ca.pem", content = tls_self_signed_cert.nomad_cluster.cert_pem },
        { path = "/etc/certs.d/cert.pem", content = tls_locally_signed_cert.consul.cert_pem },
        { path = "/etc/certs.d/cert.pem.key", content = tls_private_key.consul.private_key_pem },
        {
          path = "/etc/haproxy/haproxy.cfg"
          content = templatefile("cloud-init/haproxy.cfg", {
            consul_servers      = local.consul_servers
            nomad_servers       = local.nomad_servers
            nomad_infra_clients = local.nomad_infra_clients
          })
        }
      ]
    })
  }
}

resource "lxd_instance" "load_balancer" {
  name     = local.load_balancer["name"]
  image    = "images:ubuntu/${var.ubuntu_version}/cloud"
  profiles = ["default", lxd_profile.nomad.name]

  config = {
    "cloud-init.user-data" = data.cloudinit_config.load_balancer.rendered
    "cloud-init.network-config" = yamlencode({
      version = 2
      ethernets = {
        eth0 = {
          addresses   = ["${local.load_balancer["host"]}/16"]
          routes      = [{ to = "default", via = local.gateway_address }]
          nameservers = { addresses = ["9.9.9.9", "149.112.112.112"] }
        }
      }
    })
  }

  device {
    name = "map_port_80"
    type = "proxy"

    properties = {
      listen  = "tcp:0.0.0.0:80"
      connect = "tcp:127.0.0.1:80"
    }
  }

  device {
    name = "map_port_443"
    type = "proxy"

    properties = {
      listen  = "tcp:0.0.0.0:443"
      connect = "tcp:127.0.0.1:443"
    }
  }
}
