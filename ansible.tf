resource "local_file" "inventory" {
  filename = "./ansible/inventory/hosts"
  content = <<EOF
[all]
load-balancer ansible_host=${lxd_container.load_balancer.ipv4_address}
nfs-server ansible_host=${lxd_container.nfs_server.ipv4_address}

[consul_servers]
%{ for host in lxd_container.consul_server ~}
${host.name} ansible_host=${host.ipv4_address}
%{ endfor ~}

[nomad_servers]
%{ for host in lxd_container.nomad_server ~}
${host.name} ansible_host=${host.ipv4_address}
%{ endfor ~}

[nomad_clients:children]
nomad_infra_clients
nomad_apps_clients

[nomad_infra_clients]
%{ for host in lxd_container.nomad_infra_client ~}
${host.name} ansible_host=${host.ipv4_address}
%{ endfor ~}

[nomad_apps_clients]
%{ for host in lxd_container.nomad_apps_client ~}
${host.name} ansible_host=${host.ipv4_address}
%{ endfor ~}
EOF
}

resource "null_resource" "run_ansible" {
  depends_on = [
    local_file.inventory
  ]

  provisioner "local-exec" {
    working_dir = "./ansible"
    command = <<-EOF
      ansible-playbook playbook.yml --become -u ubuntu --key-file ../ssh/id_rsa --ssh-common-args '-o StrictHostKeyChecking=no'
    EOF
  }
}