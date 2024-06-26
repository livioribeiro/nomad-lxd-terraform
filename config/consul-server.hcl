data_dir           = "/opt/consul"
server             = true
bind_addr          = "{{ GetInterfaceIP \"eth0\" }}"
client_addr        = "127.0.0.1 {{ GetInterfaceIP \"eth0\" }}"
primary_datacenter = "dc1"

recursors = ["9.9.9.9", "149.112.112.112"]

bootstrap_expect = 3
retry_join = [
  %{~ for addr in consul_servers ~}
  "${addr}",
  %{~ endfor }
]

tls {
  defaults {
    ca_file   = "/etc/certs.d/ca.pem"
    cert_file = "/etc/certs.d/cert.pem"
    key_file  = "/etc/certs.d/key.pem"

    verify_incoming = true
    verify_outgoing = true
  }

  internal_rpc {
    verify_server_hostname = true
  }
}

auto_encrypt {
  allow_tls = true
}

encrypt = "${encrypt_key}"

addresses {
  http = "127.0.0.1"
}

ports {
  https    = 8501
  grpc     = 8502
  grpc_tls = 8503
}

connect {
  enabled = true
}

acl {
  enabled                  = true
  default_policy           = "deny"
  enable_token_persistence = true
}

ui_config {
  enabled          = true
  metrics_provider = "prometheus"
  metrics_proxy {
    base_url = "http://prometheus.service.consul:9090"
  }
}

telemetry {
  prometheus_retention_time = "10s"
  disable_hostname          = true
}

# default configuration for envoy sidecar proxy
config_entries {
  bootstrap = [
    {
      Kind = "proxy-defaults"
      Name = "global"
      Config {
        envoy_prometheus_bind_addr = "0.0.0.0:9102"
      }
    }
  ]
}