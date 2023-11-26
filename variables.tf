variable "ubuntu_version" {
  type    = string
  default = "jammy"
}

variable "ubuntu_image" {
  type    = string
  default = "images:ubuntu/jammy/cloud"
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