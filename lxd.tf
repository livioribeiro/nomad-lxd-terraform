resource "lxd_network" "nomad" {
  name = "nomadlxdbr0"

  config = {
    "ipv4.address"     = "10.99.0.1/16"
    "ipv4.nat"         = "true"
    "ipv4.dhcp.expiry" = "365d"
    "ipv4.dhcp.ranges" = "10.99.1.1-10.99.1.254"
    "ipv6.address"     = "none"
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