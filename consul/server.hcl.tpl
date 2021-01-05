data_dir = "/var/consul"

server = true
advertise_addr = "{{ GetInterfaceIP \"eth0\" }}"
client_addr = "127.0.0.1 {{ GetInterfaceIP \"eth0\" }}"

ui_config {
  enabled = true
}

connect {
  enabled = true
}

%{ if instance == 0 ~}
bootstrap_expect = 3
%{ else ~}
retry_join = [ "consul0" ]
%{ endif }
