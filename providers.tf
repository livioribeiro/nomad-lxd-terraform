terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3"
    }

    lxd = {
      source  = "terraform-lxd/lxd"
      version = "~> 2.0"
    }

    packer = {
      source  = "toowoxx/packer"
      version = "~> 0.15"
    }

    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.2"
    }

    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.18"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.21"
    }

    nomad = {
      source  = "hashicorp/nomad"
      version = "~> 2.2"
    }
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

provider "vault" {
  address          = "https://${lxd_instance.vault_server["vault-server-1"].ipv4_address}:8200"
  token            = data.local_sensitive_file.vault_root_token.content
  ca_cert_file     = local_file.cluster_ca_cert.filename
  skip_child_token = true
}

provider "nomad" {
  address   = "https://${lxd_instance.nomad_server["nomad-server-1"].ipv4_address}:4646"
  secret_id = data.local_sensitive_file.nomad_root_token.content
  ca_pem    = tls_self_signed_cert.nomad_cluster.cert_pem
  cert_pem  = tls_locally_signed_cert.consul.cert_pem
  key_pem   = tls_private_key.consul.private_key_pem
}
