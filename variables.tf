variable "ubuntu_version" {
  type    = string
  default = "noble"
}

variable "base_network" {
  type    = string
  default = "10.99.0.0/16"
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