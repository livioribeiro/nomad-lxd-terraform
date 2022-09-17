resource "lxd_container" "consul_server" {
  count    = 3
  name     = "consul-server${count.index}"
  image    = "images:ubuntu/jammy/cloud"

  config = {
    "user.user-data" = local.cloud_init
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

resource "lxd_container" "nomad_server" {
  count    = 3
  name     = "nomad-server${count.index}"
  image    = "images:ubuntu/jammy/cloud"

  config = {
    "user.user-data" = local.cloud_init
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

# resource "lxd_container" "vault_server" {
#   count    = 1
#   name     = "vault-server${cound.index}"
#   image    = "images:ubuntu/jammy/cloud"
#   profiles = [lxd_profile.nomad_cluster.name]
#
#   config = {
#     "user.user-data" = local.cloud_init
#   }
#
#
#   connection {
#     type        = "ssh"
#     user        = "ubuntu"
#     private_key = tls_private_key.nomad_cluster.private_key_pem
#     host        = self.ipv4_address
#   }
#   provisioner "remote-exec" {
#     command = "echo 1"
#   }
# }