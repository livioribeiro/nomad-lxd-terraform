variable "external_domain" {}
variable "apps_subdomain" {}
variable "vault_url" {}
variable "cacert_path" {}
variable "vault_cert_path" {}
variable "vault_private_key_path" {}

variable "vault_token" {
  sensitive = true
}