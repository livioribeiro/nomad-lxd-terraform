# CA
resource "tls_private_key" "nomad_cluster" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "nomad_cluster" {
  private_key_pem = tls_private_key.nomad_cluster.private_key_pem

  subject {
    common_name = "Nomad Cluster CA"
  }

  validity_period_hours = 87600
  early_renewal_hours   = 720
  is_ca_certificate     = true

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]
}

resource "local_file" "cluster_ca_cert" {
  filename = "${path.module}/.tmp/certs/ca.pem"
  content  = tls_self_signed_cert.nomad_cluster.cert_pem
}

resource "local_sensitive_file" "cluster_key" {
  filename = "${path.module}/.tmp/certs/ca-bundle.pem"
  content  = "${tls_self_signed_cert.nomad_cluster.cert_pem}\n${tls_private_key.nomad_cluster.private_key_pem}"
}

# Consul Server
resource "tls_private_key" "consul" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_cert_request" "consul" {
  private_key_pem = tls_private_key.consul.private_key_pem
  dns_names = concat([
    "localhost",
    "server.dc1.consul",
    "consul.service.consul",
    "consul.${var.external_domain}",
  ], keys(local.consul_servers))
  ip_addresses = concat(["127.0.0.1"], values(local.consul_servers))

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }
}

resource "tls_locally_signed_cert" "consul" {
  cert_request_pem   = tls_cert_request.consul.cert_request_pem
  ca_private_key_pem = tls_self_signed_cert.nomad_cluster.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.nomad_cluster.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "any_extended",
    "key_encipherment",
    "data_encipherment",
    "digital_signature",
    "client_auth",
    "server_auth",
  ]
}

# Consul Client
resource "tls_private_key" "consul_client" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_cert_request" "consul_client" {
  private_key_pem = tls_private_key.consul_client.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }
}

resource "tls_locally_signed_cert" "consul_client" {
  cert_request_pem   = tls_cert_request.consul_client.cert_request_pem
  ca_private_key_pem = tls_self_signed_cert.nomad_cluster.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.nomad_cluster.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "client_auth",
  ]
}

# # Vault
resource "tls_private_key" "vault" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_cert_request" "vault" {
  private_key_pem = tls_private_key.vault.private_key_pem
  dns_names = concat([
    "localhost",
    "vault.service.consul",
    "active.vault.service.consul",
    "standby.vault.service.consul",
    "vault.${var.external_domain}",
  ], keys(local.vault_servers))
  ip_addresses = concat(["127.0.0.1"], values(local.vault_servers))

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }
}

resource "tls_locally_signed_cert" "vault" {
  cert_request_pem   = tls_cert_request.vault.cert_request_pem
  ca_private_key_pem = tls_self_signed_cert.nomad_cluster.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.nomad_cluster.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "any_extended",
    "key_encipherment",
    "data_encipherment",
    "digital_signature",
    "client_auth",
    "server_auth",
  ]
}

# Nomad Server
resource "tls_private_key" "nomad_server" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_cert_request" "nomad_server" {
  private_key_pem = tls_private_key.nomad_server.private_key_pem
  dns_names = concat([
    "localhost",
    "server.global.nomad",
    "nomad.service.consul",
    "nomad.${var.external_domain}",
  ], keys(local.nomad_servers))
  ip_addresses = concat(["127.0.0.1"], values(local.nomad_servers))

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }
}

resource "tls_locally_signed_cert" "nomad_server" {
  cert_request_pem   = tls_cert_request.nomad_server.cert_request_pem
  ca_private_key_pem = tls_self_signed_cert.nomad_cluster.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.nomad_cluster.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "any_extended",
    "key_encipherment",
    "data_encipherment",
    "digital_signature",
    "client_auth",
    "server_auth",
  ]
}

# Nomad Client
resource "tls_private_key" "nomad_client" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_cert_request" "nomad_client" {
  private_key_pem = tls_private_key.nomad_client.private_key_pem
  dns_names       = ["localhost", "client.global.nomad", "nomad-client.service.consul"]
  ip_addresses    = ["127.0.0.1"]

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }
}

resource "tls_locally_signed_cert" "nomad_client" {
  cert_request_pem   = tls_cert_request.nomad_client.cert_request_pem
  ca_private_key_pem = tls_self_signed_cert.nomad_cluster.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.nomad_cluster.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "client_auth",
  ]
}

# Load balancer
resource "tls_private_key" "load_balancer" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_cert_request" "load_balancer" {
  private_key_pem = tls_private_key.load_balancer.private_key_pem
  dns_names = [
    "load-balancer",
    "consul.${var.external_domain}",
    "vault.${var.external_domain}",
    "nomad.${var.external_domain}",
    "${var.apps_subdomain}.${var.external_domain}"
  ]
  ip_addresses = ["127.0.0.1"]

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }
}

resource "tls_locally_signed_cert" "load_balancer" {
  cert_request_pem   = tls_cert_request.load_balancer.cert_request_pem
  ca_private_key_pem = tls_self_signed_cert.nomad_cluster.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.nomad_cluster.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "client_auth",
    "server_auth",
  ]
}

resource "local_file" "nomad_client_private_key" {
  filename = "${path.module}/.tmp/certs/nomad/client/private_key.pem"
  content  = tls_private_key.nomad_client.private_key_pem
}

resource "local_file" "nomad_client_public_key" {
  filename = "${path.module}/.tmp/certs/nomad/client/public_key.pem"
  content  = tls_private_key.nomad_client.public_key_pem
}

resource "local_file" "nomad_client_cert" {
  filename = "${path.module}/.tmp/certs/nomad/client/cert.pem"
  content  = tls_locally_signed_cert.nomad_client.cert_pem
}
