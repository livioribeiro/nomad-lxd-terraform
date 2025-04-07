resource "incus_network" "nomad" {
  name = "nomadincusbr0"

  config = {
    "ipv4.address"     = "${cidrhost(var.base_network, 1)}/16"
    "ipv4.nat"         = "true"
    "ipv4.dhcp.expiry" = "365d"
    "ipv4.dhcp.ranges" = "${cidrhost(var.base_network, 256 + 1)}-${cidrhost(var.base_network, 256 + 254)}"
    "ipv6.address"     = "none"
  }
}

resource "incus_storage_pool" "nomad_cluster" {
  name   = "nomad-cluster"
  driver = "dir"
  config = {
    source = "/var/lib/incus/storage-pools/nomad-cluster"
  }
}

resource "incus_profile" "nomad_cluster" {
  name = "nomad"

  device {
    name = "root"
    type = "disk"
    properties = {
      path = "/"
      pool = incus_storage_pool.nomad_cluster.name
    }
  }
}
