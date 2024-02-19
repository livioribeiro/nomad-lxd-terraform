data "cloudinit_config" "nfs_server" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = yamlencode({
      ssh_authorized_keys = [tls_private_key.ssh_nomad_cluster.public_key_openssh]
      packages = [
        "openssh-server",
        "nfs-kernel-server",
      ]
      write_files = [
        {
          path    = "/etc/exports"
          content = "/srv/nomad *(rw,fsid=0,async,no_subtree_check,no_auth_nlm,insecure,no_root_squash)"
          defer   = true
        }
      ]
      runcmd = [
        "systemctl enable nfs-server",
        "systemctl restart nfs-server",
        "exportfs -a",
      ]
    })
  }
}

resource "lxd_volume" "nfs_server_data" {
  name         = "nfs-server-data"
  pool         = lxd_storage_pool.nomad_cluster.name
  content_type = "filesystem"
}

resource "lxd_instance" "nfs_server" {
  name     = local.nfs_server["name"]
  image    = "ubuntu:${var.ubuntu_version}"
  profiles = [lxd_profile.nomad_cluster.name]

  device {
    name = "eth0"
    type = "nic"

    properties = {
      network        = lxd_network.nomad.name
      "ipv4.address" = local.nfs_server["host"]
    }
  }

  device {
    name = "nomad-data"
    type = "disk"
    properties = {
      path   = "/srv/nomad"
      source = lxd_volume.nfs_server_data.name
      pool   = lxd_volume.nfs_server_data.pool
    }
  }

  config = {
    "cloud-init.user-data" = data.cloudinit_config.nfs_server.rendered
    "security.privileged"  = true
    "security.nesting"     = true
    "raw.apparmor"         = <<-EOT
      mount fstype=nfs*,
      mount fstype=rpc_pipefs,
      mount fstype=cgroup -> /sys/fs/cgroup/**,
    EOT
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
