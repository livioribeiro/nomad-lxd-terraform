variable "traefik_version" {
  type = string
  default = "2.3.6"
}

variable "cni_plugins_version" {
  type = string
  default = "0.9.0"
}

variable "prometheus_version" {
  type = string
  default = "2.23.0"
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

data "null_data_source" "base" {
  inputs = {
    source = filesha256("packer/base.pkr.hcl")
  }
}

resource "null_resource" "base" {
  triggers = {
    source_hash = data.null_data_source.base.outputs.source
  }

  provisioner "local-exec" {
    command = "packer build base.pkr.hcl"
    working_dir = "packer"
  }
}
