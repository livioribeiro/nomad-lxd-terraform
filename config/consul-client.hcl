data_dir       = "/opt/consul"
server         = false
advertise_addr = "{{ GetInterfaceIP \"${network_interface}\" }}"
client_addr    = "127.0.0.1 {{ GetInterfaceIP \"${network_interface}\" }}"

recursors = ["208.67.222.222", "208.67.220.220"]

retry_join = [
  %{~ for addr in consul_servers ~}
  "${addr}",
  %{~ endfor }
]

ports {
  https    = 8501
  grpc     = 8502
  grpc_tls = 8503
}

connect {
  enabled = true
}

tls {
  defaults {
    ca_file         = "/etc/certs.d/ca.pem"
    verify_incoming = true
    verify_outgoing = true
  }

  internal_rpc {
    verify_server_hostname = true
  }
}

auto_encrypt {
  tls = true
}

acl {
  enabled = true
  tokens {
    agent = "${agent_token}"
  }
}

encrypt = "${encrypt_key}"
