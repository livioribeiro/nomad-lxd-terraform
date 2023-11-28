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
      runcmd = [
        "mkdir /srv/nomad",
        "systemctl enable nfs-server",
        "systemctl start nfs-server",
        "exportfs -a",
      ]
      write_files = [
        {
          path    = "/etc/exports"
          content = "/srv/nomad *(rw,sync,no_subtree_check,no_root_squash)"
          defer   = true
        }
      ]
    })
  }
}

resource "lxd_instance" "nfs_server" {
  name     = local.nfs_server["name"]
  image    = var.ubuntu_image

  device {
    name = "eth0"
    type = "nic"

    properties = {
      network = lxd_network.nomad.name
      "ipv4.address" = local.nfs_server["host"]
    }
  }

  config = {
    "cloud-init.user-data" = data.cloudinit_config.nfs_server.rendered
    "security.privileged" = true
    "raw.apparmor"        = "mount fstype=rpc_pipefs, mount fstype=nfsd,"
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
