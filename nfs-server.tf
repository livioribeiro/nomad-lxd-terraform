resource "lxd_container" "nfs_server" {
  name     = "nfs-server"
  image    = "images:ubuntu/jammy/cloud"

  config = {
    "user.user-data"      = local.cloud_init
    "security.privileged" = true
    "raw.apparmor"        = "mount fstype=rpc_pipefs, mount fstype=nfsd,"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.nomad_cluster.private_key_pem
    host        = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = ["echo 1"]
  }
}