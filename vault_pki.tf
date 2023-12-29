resource "vault_mount" "pki_root" {
  path                      = "pki-root"
  type                      = "pki"
  default_lease_ttl_seconds = 864000
  max_lease_ttl_seconds     = 864000
}

resource "vault_pki_secret_backend_config_ca" "nomad_cluster" {
  backend    = vault_mount.pki_root.path
  pem_bundle = "${tls_private_key.nomad_cluster.private_key_pem}\n${tls_self_signed_cert.nomad_cluster.cert_pem}"
}

resource "vault_mount" "pki_int" {
  path                      = "pki"
  type                      = vault_mount.pki_root.type
  description               = "intermediate"
  default_lease_ttl_seconds = 86400
  max_lease_ttl_seconds     = 86400
}

resource "vault_pki_secret_backend_intermediate_cert_request" "pki_int" {
  backend     = vault_mount.pki_int.path
  type        = "internal"
  common_name = "Vault Intermediate CA"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "pki_int" {
  backend              = vault_mount.pki_root.path
  csr                  = vault_pki_secret_backend_intermediate_cert_request.pki_int.csr
  common_name          = "Vault Intermediate CA"
  exclude_cn_from_sans = true
  revoke               = true
}

resource "vault_pki_secret_backend_intermediate_set_signed" "example" {
  backend     = vault_mount.pki_int.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.pki_int.certificate
}

resource "vault_pki_secret_backend_role" "nomad_cluster" {
  backend        = vault_mount.pki_int.path
  name           = "nomad-cluster"
  max_ttl        = 4320
  require_cn     = false
  generate_lease = true
  allow_ip_sans  = true
  key_type       = "rsa"
  key_bits       = 4096
  allowed_domains = [
    "global.nomad",
    "dc1.consul",
    "node.consul",
    "service.consul",
    "${var.external_domain}",
    "${var.apps_subdomain}.${var.external_domain}",
  ]
  allow_subdomains = true
}

resource "vault_policy" "tls" {
  name = "tls"

  policy = <<-EOT
    path "pki/issue/${vault_pki_secret_backend_role.nomad_cluster.name}" {
      capabilities = ["update"]
    }
  EOT
}
