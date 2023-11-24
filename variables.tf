variable "ubuntu_version" {
  type    = string
  default = "jammy"
}

variable "external_domain" {
  type    = string
  default = "localhost"
}

variable "apps_subdomain" {
  type    = string
  default = "apps"
}

variable "gateway_address" {
  type    = string
  default = "10.99.0.1"
}