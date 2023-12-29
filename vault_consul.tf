# data "consul_acl_policy" "global_management" {
#   depends_on = [null_resource.ansible_consul]
#   name  = "global-management"
# }

# resource "consul_acl_token" "vault_consul_secret_backend" {
#   description = "Vault Consul secret backend"
#   policies    = [data.consul_acl_policy.global_management.name]
# }

# data "consul_acl_token_secret_id" "vault_consul_secret_backend" {
#   accessor_id = consul_acl_token.vault_consul_secret_backend.id
# }

# resource "vault_consul_secret_backend" "consul" {
#   path        = "consul"
#   description = "Manages the Consul backend"
#   address     = "127.0.0.1:8500"
#   token       = data.consul_acl_token_secret_id.vault_consul_secret_backend.secret_id
# }

# resource "vault_policy" "consul_creds" {
#   name = "consul-creds"

#   policy = <<-EOT
#     path "consul/creds/{{identity.entity.aliases.${module.nomad_vault_setup.auth_backend_accessor}.metadata.nomad_namespace}}" {
#       capabilities = ["read"]
#     }
#   EOT
# }
