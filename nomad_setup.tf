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

# resource "vault_jwt_auth_backend" "nomad" {
#   description = "JWT auth backend for Nomad"
#   path        = "jwt-nomad"
#   jwks_url    = "http://nomad.localhost/.well-known/jwks.json"
#   jwt_supported_algs = ["RS256"]
# }

# resource "vault_policy" "nomad_workload" {
#   name = "nomad-workload"

#   policy = <<-EOT
#     path "secret/data/{{identity.entity.aliases.${vault_jwt_auth_backend.nomad.accessor}.metadata.nomad_namespace}}/{{identity.entity.aliases.${vault_jwt_auth_backend.nomad.accessor}.metadata.nomad_job_id}}/*" {
#       capabilities = ["read"]
#     }

#     path "secret/data/{{identity.entity.aliases.${vault_jwt_auth_backend.nomad.accessor}.metadata.nomad_namespace}}/{{identity.entity.aliases.${vault_jwt_auth_backend.nomad.accessor}.metadata.nomad_job_id}}" {
#       capabilities = ["read"]
#     }

#     path "secret/metadata/{{identity.entity.aliases.${vault_jwt_auth_backend.nomad.accessor}.metadata.nomad_namespace}}/*" {
#       capabilities = ["list"]
#     }

#     path "secret/metadata/*" {
#       capabilities = ["list"]
#     }
#   EOT
# }

# resource "vault_jwt_auth_backend_role" "nomad_workload" {
#   backend         = vault_jwt_auth_backend.nomad.path
#   role_name       = "nomad-workload"
#   role_type       = "jwt"
#   bound_audiences = ["vault.io"]
#   user_claim      = "/nomad_job_id"
#   user_claim_json_pointer = true

#   claim_mappings = {
#     nomad_namespace = "nomad_namespace"
#     nomad_job_id    = "nomad_job_id"
#   }

#   token_period    = 1800
#   token_type      = "service"
#   token_policies  = [vault_policy.tls_policy.name, vault_policy.nomad_workload.name]
# }