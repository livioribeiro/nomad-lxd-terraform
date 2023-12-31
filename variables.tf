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

variable "nomad_infra_clients_qtd" {
  type    = number
  default = 2
}

variable "nomad_apps_clients_qtd" {
  type    = number
  default = 3
}