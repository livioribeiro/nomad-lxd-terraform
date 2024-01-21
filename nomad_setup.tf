locals {
  auth_method_name  = "nomad-workloads"
  tasks_role_prefix = "nomad-tasks"
}

module "nomad_consul_setup" {
  depends_on = [
    null_resource.ansible_consul,
    null_resource.ansible_nomad_server,
  ]

  source  = "hashicorp-modules/nomad-setup/consul"
  version = "2.0.0"

  nomad_jwks_url   = "http://nomad.${var.external_domain}/.well-known/jwks.json"
  auth_method_name = local.auth_method_name
  nomad_namespaces = [
    "system",
    "default",
  ]
}

data "consul_acl_auth_method" "nomad" {
  depends_on = [module.nomad_consul_setup]
  name       = local.auth_method_name
}

resource "consul_acl_binding_rule" "job_tasks" {
  auth_method = data.consul_acl_auth_method.nomad.name
  description = "Binding rule for Nomad tasks with job id"
  bind_type   = "role"
  bind_name   = "${local.tasks_role_prefix}-$${value.nomad_namespace}-$${value.nomad_job_id}"
  selector    = "\"nomad_service\" not in value"
}

module "nomad_vault_setup" {
  depends_on = [
    null_resource.ansible_vault,
    null_resource.ansible_nomad_server,
  ]

  source  = "hashicorp-modules/nomad-setup/vault"
  version = "1.1.0"

  nomad_jwks_url = "http://nomad.${var.external_domain}/.well-known/jwks.json"
  policy_names   = [vault_policy.nomad_workloads.name]
}

resource "vault_policy" "nomad_workloads" {
  name   = "nomad-workloads"
  policy = <<-EOT
    path "secret/data/{{identity.entity.aliases.${module.nomad_vault_setup.auth_backend_accessor}.metadata.nomad_namespace}}/{{identity.entity.aliases.${module.nomad_vault_setup.auth_backend_accessor}.metadata.nomad_job_id}}/*" {
      capabilities = ["read"]
    }

    path "secret/data/{{identity.entity.aliases.${module.nomad_vault_setup.auth_backend_accessor}.metadata.nomad_namespace}}/{{identity.entity.aliases.${module.nomad_vault_setup.auth_backend_accessor}.metadata.nomad_job_id}}" {
      capabilities = ["read"]
    }

    path "secret/metadata/{{identity.entity.aliases.${module.nomad_vault_setup.auth_backend_accessor}.metadata.nomad_namespace}}/*" {
      capabilities = ["list"]
    }

    path "secret/metadata/*" {
      capabilities = ["list"]
    }

    path "pki/issue/${vault_pki_secret_backend_role.nomad_cluster.name}" {
      capabilities = ["update"] 
    }
  EOT
}
