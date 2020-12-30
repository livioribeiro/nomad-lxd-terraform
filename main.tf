variable "traefik_version" {
  type = string
  default = "2.3.6"
}

variable "cni_plugins_version" {
  type = string
  default = "0.9.0"
}

locals {
  traefik_url = "https://github.com/traefik/traefik/releases/download/v${var.traefik_version}/traefik_v${var.traefik_version}_linux_amd64.tar.gz"
  cni_plugins_url = "https://github.com/containernetworking/plugins/releases/download/v${var.cni_plugins_version}/cni-plugins-linux-amd64-v${var.cni_plugins_version}.tgz"
  hashicorp_gpg = file("./gpg/hashicorp.gpg")
  envoy_gpg = file("./gpg/envoy.gpg")
  docker_gpg = file("./gpg/docker.gpg")
}

terraform {
  required_providers {
    lxd = {
      source  = "terraform-lxd/lxd"
      version = "1.5.0"
    }
  }
}

provider "lxd" {
  generate_client_certificates = true
  accept_remote_certificate    = true
}

resource "lxd_cached_image" "ubuntu" {
  source_remote = "ubuntu"
  source_image  = "focal/amd64"

  lifecycle {
    prevent_destroy = true
  }
}