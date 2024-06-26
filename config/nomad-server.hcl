data_dir = "/opt/nomad"

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
  enabled = true
  token   = "${consul_token}"

  service_identity {
    aud = ["consul.io"]
    ttl = "1h"
  }

  task_identity {
    aud = ["consul.io"]
    ttl = "1h"
  }
}

vault {
  enabled = true

  default_identity {
    aud = ["vault.io"]
    ttl = "1h"
  }
}


telemetry {
  collection_interval        = "10s"
  prometheus_metrics         = true
  disable_hostname           = true
  publish_allocation_metrics = true
  publish_node_metrics       = true
}
