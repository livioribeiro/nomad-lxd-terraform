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
