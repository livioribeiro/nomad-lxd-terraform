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

resource "incus_storage_volume" "nfs_server_data" {
  name         = "nfs-server-data"
  pool         = incus_storage_pool.nomad_cluster.name
  content_type = "filesystem"
}

resource "incus_instance" "nfs_server" {
  name     = local.nfs_server["name"]
  image    = "${var.ubuntu_image}"
  profiles = [incus_profile.nomad_cluster.name]

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

  device {
    name = "eth0"
    type = "nic"

    properties = {
      network        = incus_network.nomad.name
      "ipv4.address" = local.nfs_server["host"]
    }
  }

  device {
    name = "nomad-data"
    type = "disk"
    properties = {
      path   = "/srv/nomad"
      source = incus_storage_volume.nfs_server_data.name
      pool   = incus_storage_volume.nfs_server_data.pool
    }
  }

  wait_for {
    type = "ipv4"
    nic = "eth0"
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
