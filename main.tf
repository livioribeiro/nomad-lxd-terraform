data "http" "hashicorp_gpg" {
  url = "https://apt.releases.hashicorp.com/gpg"
}

resource "lxd_network" "nomad" {
  name = "nomadlxdbr0"

  config = {
    "ipv4.address" = "10.99.0.1/16"
    "ipv4.nat"     = "true"
    "ipv6.address" = "none"
  }
}

resource "lxd_storage_pool" "nomad_cluster" {
  name   = "nomad-cluster"
  driver = "dir"
  config = {
    source = "/var/snap/lxd/common/lxd/storage-pools/nomad-cluster"
  }
}

resource "lxd_profile" "nomad_cluster" {
  name = "nomad"

  device {
    name = "root"
    type = "disk"
    properties = {
      path = "/"
      pool = lxd_storage_pool.nomad_cluster.name
    }
  }
}

resource "tls_private_key" "ssh_nomad_cluster" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "ssh_private_key" {
  filename = ".tmp/ssh/id_rsa"
  content  = tls_private_key.ssh_nomad_cluster.private_key_openssh
}

data "tls_public_key" "ssh_nomad_cluster" {
  private_key_openssh = tls_private_key.ssh_nomad_cluster.private_key_openssh
}

resource "local_file" "ssh_public_key" {
  filename = ".tmp/ssh/id_rsa.pub"
  content  = data.tls_public_key.ssh_nomad_cluster.public_key_openssh
}

resource "random_string" "nomad_encrypt_key" {
  length = 16
}
