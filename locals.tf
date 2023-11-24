locals {
  consul_servers = {
    for i in [1, 2, 3] : "consul-server-${i}" => "10.99.0.${10 + i}"
  }
  vault_servers = {
    for i in [1, 2, 3] : "vault-server$-${i}" => "10.99.0.${20 + i}"
  }
  nomad_servers = {
    for i in [1, 2, 3] : "nomad-server-${i}" => "10.99.0.${30 + i}"
  }
  nomad_infra_clients = {
    for i in [1, 2] : "nomad-infra-client-${i}" => "10.99.1.${i}"
  }
  nomad_apps_clients = {
    for i in [1, 2, 3] : "nomad-apps-client-${i}" => "10.99.1.${10 + i}"
  }
  nfs_server      = { name = "nfs-server", host = "10.99.0.200" }
  load_balancer   = { name = "load-balancer", host = "10.99.0.254" }
  gateway_address = "10.99.0.1"
}