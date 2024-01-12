resource "tls_private_key" "ssh_nomad_cluster" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "ssh_private_key" {
  filename = ".tmp/ssh/id_rsa"
  content  = tls_private_key.ssh_nomad_cluster.private_key_openssh
}

resource "local_file" "ssh_public_key" {
  filename = ".tmp/ssh/id_rsa.pub"
  content  = tls_private_key.ssh_nomad_cluster.public_key_openssh
}