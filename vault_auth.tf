resource "vault_identity_entity" "admin" {
  name = "admin"
}

resource "vault_identity_entity" "operator" {
  name = "operator"
}

resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

resource "null_resource" "userpass_users" {
  depends_on = [vault_auth_backend.userpass]
  for_each   = toset(["admin", "operator"])

  provisioner "local-exec" {
    environment = {
      VAULT_ADDR        = "https://${lxd_instance.vault_server["vault-server-1"].ipv4_address}:8200"
      VAULT_TOKEN       = data.local_sensitive_file.vault_root_token.content
      VAULT_CACERT      = local_file.cluster_ca_cert.filename
      VAULT_CLIENT_CERT = local_file.vault_cert.filename
      VAULT_CLIENT_KEY  = local_sensitive_file.vault_key.filename
    }
    command = "vault write auth/userpass/users/${each.key} password=${each.key}"
  }
}

resource "vault_identity_entity_alias" "admin" {
  name           = "admin"
  mount_accessor = vault_auth_backend.userpass.accessor
  canonical_id   = vault_identity_entity.admin.id
}

resource "vault_identity_entity_alias" "operator" {
  name           = "operator"
  mount_accessor = vault_auth_backend.userpass.accessor
  canonical_id   = vault_identity_entity.operator.id
}

resource "vault_policy" "nomad_admin" {
  name = "nomad-admin"

  policy = <<-EOT
    path "secret/nomad/*" {
      capabilities = ["create", "read", "update", "patch", "delete", "list"]
    }
  EOT
}

resource "vault_policy" "nomad_operator" {
  name = "nomad-operator"

  policy = <<-EOT
    path "secret/nomad/jobs/*" {
      capabilities = ["create", "read", "update", "patch", "delete", "list"]
    }

    path "secret/nomad/jobs/system-*" {
      capabilities = ["deny"]
    }
  EOT
}

resource "vault_identity_group" "admin" {
  name              = "admin"
  type              = "internal"
  policies          = [vault_policy.nomad_admin.name]
  member_entity_ids = [vault_identity_entity.admin.id]
}

resource "vault_identity_group" "operator" {
  name              = "operator"
  type              = "internal"
  policies          = [vault_policy.nomad_operator.name]
  member_entity_ids = [vault_identity_entity.operator.id]
}

resource "vault_identity_oidc_assignment" "nomad" {
  name = "nomad"
  group_ids = [
    vault_identity_group.admin.id,
    vault_identity_group.operator.id,
  ]
}

resource "vault_identity_oidc_key" "nomad" {
  depends_on = [
    vault_auth_backend.userpass
  ]

  name               = "nomad"
  allowed_client_ids = ["*"]
  verification_ttl   = 7200
  rotation_period    = 3600
  algorithm          = "RS256"
}

resource "vault_identity_oidc_client" "nomad" {
  name = "nomad"
  redirect_uris = [
    "http://localhost:4649/oidc/callback",
    "http://nomad.${var.external_domain}/ui/settings/tokens",
    "https://nomad.${var.external_domain}/ui/settings/tokens",
  ]
  assignments = [
    vault_identity_oidc_assignment.nomad.name
  ]
  id_token_ttl     = 1800
  access_token_ttl = 3600
}

resource "vault_identity_oidc_scope" "groups" {
  name        = "groups"
  template    = "{\"groups\":{{identity.entity.groups.names}}}"
  description = "Vault OIDC Groups Scope"
}

resource "vault_identity_oidc_provider" "nomad" {
  name        = "nomad"
  issuer_host = "vault.${var.external_domain}"

  allowed_client_ids = [
    vault_identity_oidc_client.nomad.client_id
  ]

  scopes_supported = [
    vault_identity_oidc_scope.groups.name
  ]
}
