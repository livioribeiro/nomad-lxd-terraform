terraform {
  required_providers {
    lxd = {
      source = "terraform-lxd/lxd"
      version = "~> 1.7"
    }

    tls = {
      source = "hashicorp/tls"
      version = "~> 4.0"
    }

    local = {
      source = "hashicorp/local"
      version = "~> 2.2"
    }

    null = {
      source = "hashicorp/null"
      version = "~> 3.1"
    }

    nomad = {
      source = "hashicorp/nomad"
      version = "~> 1.4"
    }
  }
}

provider "lxd" {
    generate_client_certificates = true
    accept_remote_certificate = true
}

provider "tls" {}

provider "local" {}

provider "null" {}

provider "nomad" {
  address = "http://${lxd_container.nomad_server[0].ipv4_address}:4646"
}
