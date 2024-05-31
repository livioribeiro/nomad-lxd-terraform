ui = true
disable_mlock = true

api_addr     = "https://{{ GetInterfaceIP \"eth0\" }}:8200"
cluster_addr = "https://{{ GetInterfaceIP \"eth0\" }}:8201"

listener "tcp" {
  address            = "0.0.0.0:8200"
  tls_cert_file      = "/etc/certs.d/cert.pem"
  tls_key_file       = "/etc/certs.d/key.pem"
  tls_client_ca_file = "/etc/certs.d/ca.pem"

  telemetry {
    unauthenticated_metrics_access = true
  }
}

storage "raft" {
  path    = "/opt/vault"
  node_id = "${hostname}"

  %{~ for name, addr in vault_servers ~}
  %{~ if name != hostname ~}
  retry_join {
    leader_api_addr         = "https://${addr}:8200"
    leader_ca_cert_file     = "/etc/certs.d/ca.pem"
    leader_client_cert_file = "/etc/certs.d/cert.pem"
    leader_client_key_file  = "/etc/certs.d/key.pem"
  }
  %{~ endif }
  %{~ endfor }
}

service_registration "consul" {
  token = "${consul_token}"
}

telemetry {
  disable_hostname = true
}