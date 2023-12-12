module "nomad-consul-setup" {
  depends_on = [
    null_resource.ansible_consul,
    null_resource.ansible_nomad_server,
  ]
  source  = "hashicorp-modules/nomad-setup/consul"
  version = "2.0.0"

  nomad_jwks_url = "http://nomad.${var.external_domain}/.well-known/jwks.json"
}

module "nomad-vault-setup" {
  depends_on = [
    null_resource.ansible_vault,
    null_resource.ansible_nomad_server,
  ]
  source  = "hashicorp-modules/nomad-setup/vault"
  version = "1.1.0"

  nomad_jwks_url = "http://nomad.${var.external_domain}/.well-known/jwks.json"
  policy_names = [vault_policy.tls_policy.name]
}
