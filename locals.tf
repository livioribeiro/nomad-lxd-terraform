locals {
  consul_servers = {
    for i in range(1, 4) : "consul-server-${i}" => cidrhost(var.base_network, 10 + i)
  }

  vault_servers = {
    for i in range(1, 4) : "vault-server-${i}" => cidrhost(var.base_network, 20 + i)
  }

  nomad_servers = {
    for i in range(1, 4) : "nomad-server-${i}" => cidrhost(var.base_network, 30 + i)
  }

  nomad_infra_clients = {
    for i in range(1, var.nomad_infra_clients_qtd + 1) :
    "nomad-infra-client-${i}" => cidrhost(var.base_network, 40 + i)
  }

  nfs_server    = { name = "nfs-server", host = cidrhost(var.base_network, 200) }
  load_balancer = { name = "load-balancer", host = cidrhost(var.base_network, 254) }
}