module "vault" {
  depends_on = [
    null_resource.ansible_vault,
  ]
  source = "./modules/vault"

  external_domain     = var.external_domain
  apps_subdomain      = var.apps_subdomain
  root_ca_private_key = tls_private_key.nomad_cluster.private_key_pem
  root_ca_cert        = tls_self_signed_cert.nomad_cluster.cert_pem
}

module "nomad" {
  depends_on = [
    lxd_instance.nfs_server,
    null_resource.ansible_nomad_server,
    lxd_instance.nomad_client,
    module.vault,
  ]
  source = "./modules/nomad"

  external_domain = var.external_domain
  apps_subdomain  = var.apps_subdomain
  nfs_server_host = local.nfs_server["host"]
}