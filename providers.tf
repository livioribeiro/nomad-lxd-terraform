terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }

    lxd = {
      source  = "terraform-lxd/lxd"
      version = "~> 1.10"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }

    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.1"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3"
    }

    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.20"
    }

    # vault =  {
    #   source = "hashicorp/vault"
    #   version = "~> 3.23"
    # }

    # nomad = {
    #   source = "hashicorp/nomad"
    #   version = "~> 2.0"
    # }
  }
}

provider "lxd" {
  generate_client_certificates = true
  accept_remote_certificate    = true
}

provider "consul" {
  address  = "https://${lxd_instance.consul_server["consul-server-1"].ipv4_address}:8501"
  token    = data.local_sensitive_file.consul_root_token.content
  ca_pem   = tls_self_signed_cert.nomad_cluster.cert_pem
  cert_pem = tls_locally_signed_cert.consul.cert_pem
  key_pem  = tls_private_key.consul.private_key_pem
}

# provider "nomad" {
#   address = "http://${lxd_container.nomad_server[0].ipv4_address}:4646"
# }
