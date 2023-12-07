resource "null_resource" "setup_ansible" {
  provisioner "local-exec" {
    command = <<-EOT
      python -m venv .venv
      .venv/bin/pip install ansible
      .venv/bin/ansible-galaxy collection install cloud.terraform
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -r .venv .tmp/root_token_*.txt || true"
  }
}

resource "ansible_group" "consul_servers" {
  name = "consul_servers"
}

resource "ansible_host" "consul_server" {
  for_each = local.consul_servers

  name   = each.key
  groups = [ansible_group.consul_servers.name]

  variables = {
    ansible_host = each.value
  }
}

resource "ansible_group" "vault_servers" {
  name = "vault_servers"
}

resource "ansible_host" "vault_server" {
  for_each = local.vault_servers

  name   = each.key
  groups = [ansible_group.vault_servers.name]

  variables = {
    ansible_host = each.value
  }
}

resource "ansible_group" "nomad_servers" {
  name = "nomad_servers"
}

resource "ansible_host" "nomad_server" {
  for_each = local.nomad_servers

  name   = each.key
  groups = [ansible_group.nomad_servers.name]

  variables = {
    ansible_host = each.value
  }
}
