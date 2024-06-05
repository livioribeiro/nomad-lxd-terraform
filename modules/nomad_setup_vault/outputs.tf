# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "auth_backend_accessor" {
  description = "The accessor of the JWT auth backend created for Nomad tasks."
  value       = vault_jwt_auth_backend.nomad.accessor
}

output "auth_backend_path" {
  description = "The path of the JWT auth backend created for Nomad tasks."
  value       = vault_jwt_auth_backend.nomad.path
}

output "role_name" {
  description = "The name of the ACL role applied to tokens created using the Nomad JWT auth method."
  value       = vault_jwt_auth_backend_role.nomad_workload.role_name
}

output "policy_names" {
  description = "The name of the ACL policies applied to tokens created using the Nomad JWT auth method."
  value       = local.policy_names
}

output "nomad_client_config" {
  description = "A sample Vault configuration to be set in a Nomad client agent configuration file."
  value       = <<EOF
vault {
  enabled = true
  address = "<Vault address>"

  # Vault Enterprise only.
  # namespace = "<namespace>"

  # Vault mTLS configuration.
  # ca_path     = "/etc/certs/ca"
  # cert_file   = "/var/certs/vault.crt"
  # key_file    = "/var/certs/vault.key"

  jwt_auth_backend_path = "${vault_jwt_auth_backend.nomad.path}"
}
EOF
}

output "nomad_server_config" {
  description = "A sample Vault configuration to be set in a Nomad server agent configuration file."
  value       = <<EOF
vault {
  enabled = true

  default_identity {
    aud = ["${var.audience}"]
    ttl = "1h"
  }
}
EOF
}
