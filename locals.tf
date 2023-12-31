locals {
  consul_servers = {
    for i in range(1, 4) : "consul-server-${i}" => "10.99.0.${10 + i}"
  }
  vault_servers = {
    for i in range(1, 4) : "vault-server-${i}" => "10.99.0.${20 + i}"
  }
  nomad_servers = {
    for i in range(1, 4) : "nomad-server-${i}" => "10.99.0.${30 + i}"
  }
  nomad_infra_clients = {
    for i in range(1, var.nomad_infra_clients_qtd + 1) : "nomad-infra-client-${i}" => "10.99.0.${40 + i}"
  }
  nfs_server    = { name = "nfs-server", host = "10.99.0.200" }
  load_balancer = { name = "load-balancer", host = "10.99.0.254" }
}