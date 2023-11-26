resource "vault_mount" "pki" {
  path                      = "pki"
  type                      = "pki"
  default_lease_ttl_seconds = 864000
  max_lease_ttl_seconds     = 864000
}

resource "vault_pki_secret_backend_config_ca" "nomad_cluster" {
  backend = vault_mount.pki.path
  pem_bundle = "${var.root_ca_private_key}\n${var.root_ca_cert}"
}

data "vault_pki_secret_backend_issuers" "pki" {
  depends_on = [ vault_pki_secret_backend_config_ca.nomad_cluster ]
  backend    = vault_mount.pki.path
}

# resource "vault_pki_secret_backend_config_issuers" "root" {
#   backend                       = vault_mount.pki_int.path
#   default                       = data.vault_pki_secret_backend_issuers.pki.keys[0]
#   default_follows_latest_issuer = true
# }

resource "vault_mount" "pki_int" {
  path                      = "pki-int"
  type                      = vault_mount.pki.type
  description               = "intermediate"
  default_lease_ttl_seconds = 86400
  max_lease_ttl_seconds     = 86400
}

# resource "vault_pki_secret_backend_root_cert" "root" {
#   backend              = vault_mount.pki.path
#   type                 = "internal"
#   common_name          = "Vault Root CA"
#   ttl                  = 86400
#   format               = "pem"
#   private_key_format   = "der"
#   key_type             = "rsa"
#   key_bits             = 4096
#   exclude_cn_from_sans = true
# }

resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate" {
  backend               = vault_mount.pki.path
  type                  = "internal"
  common_name           = "Vault Intermediate CA"
  add_basic_constraints = true
}

resource "vault_pki_secret_backend_root_sign_intermediate" "intermediate" {
  backend              = vault_mount.pki.path
  csr                  = vault_pki_secret_backend_intermediate_cert_request.intermediate.csr
  common_name          = "Vault Intermediate CA"
  exclude_cn_from_sans = true
  revoke               = true
  issuer_ref           = "default"
}

resource "vault_pki_secret_backend_intermediate_set_signed" "intermediate" {
  backend     = vault_mount.pki_int.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.intermediate.certificate
}

data "vault_pki_secret_backend_issuer" "intermediate" {
  backend     = vault_mount.pki_int.path
  issuer_ref  = vault_pki_secret_backend_intermediate_set_signed.intermediate.imported_issuers[0]
}

resource "vault_pki_secret_backend_config_issuers" "config" {
  backend                       = vault_mount.pki_int.path
  default                       = data.vault_pki_secret_backend_issuer.intermediate.issuer_id
  default_follows_latest_issuer = true
}

resource "vault_pki_secret_backend_role" "nomad_cluster" {
  backend          = vault_mount.pki.path
  name             = "nomad-cluster"
  max_ttl          = 4320
  require_cn       = false
  generate_lease   = true
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  allowed_domains  = [
    "global.nomad",
    "dc1.consul",
    "node.consul",
    "service.consul",
    "${var.external_domain}",
    "${var.apps_subdomain}.${var.external_domain}",
  ]
  allow_subdomains = true
}

resource "vault_policy" "tls_policy" {
  name = "tls-policy"

  policy = <<-EOT
    path "pki/issue/nomad-cluster" {
      capabilities = ["update"]
    }
  EOT
}
