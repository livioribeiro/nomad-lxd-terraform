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
        { path = "/etc/certs.d/cert.pem", content = tls_locally_signed_cert.load_balancer.cert_pem },
        { path = "/etc/certs.d/cert.pem.key", content = tls_private_key.load_balancer.private_key_pem },
        {
          path = "/etc/haproxy/haproxy.cfg"
          content = templatefile("config/haproxy.cfg", {
            external_domain     = var.external_domain
            consul_servers      = local.consul_servers
            vault_servers       = local.vault_servers
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
  image    = var.ubuntu_image
  profiles = ["default", lxd_profile.nomad.name]

  device {
    name = "eth0"
    type = "nic"

    properties = {
      network = lxd_network.nomad.name
      "ipv4.address" = local.load_balancer["host"]
    }
  }

  config = {
    "cloud-init.user-data" = data.cloudinit_config.load_balancer.rendered
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

  provisioner "remote-exec" {
    connection {
      host        = self.ipv4_address
      user        = "ubuntu"
      private_key = data.tls_public_key.ssh_nomad_cluster.private_key_openssh
    }
    inline = ["cloud-init status -w > /dev/null"]
  }
}
