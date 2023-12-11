data_dir = "/opt/nomad/data"

server {
  enabled          = true
  bootstrap_expect = 3
  raft_protocol    = 3
  encrypt          = "${encrypt_key}"
}

acl {
  enabled = true
}

tls {
  http      = true
  rpc       = true

  ca_file   = "/etc/certs.d/ca.pem"
  cert_file = "/etc/certs.d/cert.pem"
  key_file  = "/etc/certs.d/key.pem"

  verify_server_hostname = true
  verify_https_client    = true
}

consul {
  token = "${consul_token}"
}

vault {
  enabled = true

  default_identity {
    aud = ["vault.io"]
    ttl = "1h"
  }
}


telemetry {
  prometheus_metrics         = true
  disable_hostname           = true
  publish_allocation_metrics = true
  publish_node_metrics       = true
}
