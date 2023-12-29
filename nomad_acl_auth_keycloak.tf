resource "nomad_acl_auth_method" "keycloak" {
  depends_on = [module.nomad]

  name           = "keycloak"
  type           = "OIDC"
  token_locality = "global"
  max_token_ttl  = "10m0s"
  default        = false

  config {
    oidc_discovery_url = "https://keycloak.${var.apps_subdomain}.${var.external_domain}/realms/nomad"
    oidc_client_id     = "nomad"
    oidc_client_secret = "nomad-oidc-authentication-secret"
    oidc_scopes        = ["groups"]
    bound_audiences    = ["nomad"]
    allowed_redirect_uris = [
      "http://localhost:4649/oidc/callback",
      "http://nomad.${var.external_domain}/ui/settings/tokens",
      "https://nomad.${var.external_domain}/ui/settings/tokens",
    ]
    list_claim_mappings = {
      "groups" : "roles"
    }
  }
}

resource "nomad_acl_binding_rule" "admin_keycloak" {
  description = "admin keycloak"
  auth_method = nomad_acl_auth_method.keycloak.name
  selector    = "admin in list.roles"
  bind_type   = "role"
  bind_name   = "admin"
}

resource "nomad_acl_binding_rule" "operator_keycloak" {
  description = "operator keycloak"
  auth_method = nomad_acl_auth_method.keycloak.name
  selector    = "operator in list.roles"
  bind_type   = "role"
  bind_name   = "operator"
}