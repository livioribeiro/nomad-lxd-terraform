resource "tls_private_key" "nomad_cluster" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "ssh_private_key" {
  filename = "./ssh/id_rsa"
  content = tls_private_key.nomad_cluster.private_key_pem
}

locals {
  cloud_init = templatefile("./cloud-init.yaml.tpl", {
    ssh_key = tls_private_key.nomad_cluster.public_key_openssh
  })
}