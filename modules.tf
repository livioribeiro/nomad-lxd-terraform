module "nomad_jobs" {
  depends_on = [
    lxd_instance.nfs_server,
    null_resource.ansible_nomad_server,
    lxd_instance.nomad_client,
    vault_pki_secret_backend_role.nomad_cluster,
    module.nomad_consul_setup,
    module.nomad_vault_setup,
  ]
  source = "./modules/nomad_jobs"

  external_domain = var.external_domain
  apps_subdomain  = var.apps_subdomain
  nfs_server_host = local.nfs_server["host"]
}

module "nomad_auth" {
  depends_on = [module.nomad_jobs]
  source     = "./modules/nomad_auth"

  external_domain        = var.external_domain
  apps_subdomain         = var.apps_subdomain
  vault_url              = "https://${lxd_instance.vault_server["vault-server-1"].ipv4_address}:8200"
  cacert_path            = local_file.cluster_ca_cert.filename
  vault_cert_path        = local_file.vault_cert.filename
  vault_private_key_path = local_sensitive_file.vault_key.filename
  vault_token            = data.local_sensitive_file.vault_root_token.content
}