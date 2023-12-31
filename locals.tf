locals {
  consul_servers = {
    for i in range(3) : "consul-server-${i + 1}" => "10.99.0.${10 + i}"
  }
  vault_servers = {
    for i in range(3) : "vault-server-${i + 1}" => "10.99.0.${20 + i}"
  }
  nomad_servers = {
    for i in range(3) : "nomad-server-${i + 1}" => "10.99.0.${30 + i}"
  }
  nomad_infra_clients = {
    for i in range(var.nomad_infra_clients_qtd) : "nomad-infra-client-${i + 1}" => "10.99.0.${40 + i}"
  }
  nfs_server    = { name = "nfs-server", host = "10.99.0.200" }
  load_balancer = { name = "load-balancer", host = "10.99.0.254" }
}