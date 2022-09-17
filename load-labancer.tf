resource "lxd_container" "load_balancer" {
  name     = "load-balancer"
  image    = "images:ubuntu/jammy/cloud"

  config = {
    "user.user-data" = local.cloud_init
  }

  device {
    name = "map_port_80"
    type = "proxy"
  
    properties = {
      listen = "tcp:0.0.0.0:80"
      connect = "tcp:127.0.0.1:80"
    }
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