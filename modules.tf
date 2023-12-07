module "nomad" {
  depends_on = [
    lxd_instance.nfs_server,
    null_resource.ansible_nomad_server,
    lxd_instance.nomad_client,
    vault_pki_secret_backend_role.nomad_cluster,
  ]
  source = "./modules/nomad"

  external_domain = var.external_domain
  apps_subdomain  = var.apps_subdomain
  nfs_server_host = local.nfs_server["host"]
}