data "cloudinit_config" "nfs_server" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = yamlencode({
      ssh_authorized_keys = [tls_private_key.ssh_nomad_cluster.public_key_openssh]
      packages = ["openssh-server", "nfs-kernel-server"]
      runcmd = ["mkdir /srv/nomad"]
      write_files = [
        {
          path = "/etc/exports"
          content = "/srv/nomad *(rw,sync,no_subtree_check,no_root_squash)"
        }
      ]
    })
  }
}

resource "lxd_instance" "nfs_server" {
  name     = local.nfs_server["name"]
  image    = "images:ubuntu/${var.ubuntu_version}/cloud"
  profiles = ["default", lxd_profile.nomad.name]

  config = {
    "cloud-init.user-data" = data.cloudinit_config.load_balancer.rendered
    "cloud-init.network-config" = yamlencode({
      version = 2
      ethernets = {
        eth0 = {
          addresses   = ["${local.nfs_server["host"]}/16"]
          routes      = [{ to = "default", via = local.gateway_address }]
          nameservers = { addresses = ["9.9.9.9", "149.112.112.112"] }
        }
      }
    })
    "security.privileged" = true
    "raw.apparmor"        = "mount fstype=rpc_pipefs, mount fstype=nfsd,"
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
