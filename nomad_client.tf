data "null_data_source" "nomad_client" {
  inputs = {
    source = filesha256("packer/nomad-client.pkr.hcl")
  }
}

resource "null_resource" "nomad_client" {
  depends_on = [ null_resource.nomad ]

  triggers = {
    source_hash = data.null_data_source.nomad_client.outputs.source
  }

  provisioner "local-exec" {
    command = "packer build -var 'cni_plugins_version=${var.cni_plugins_version}' nomad-client.pkr.hcl"
    working_dir = "packer"
  }
}

resource "lxd_container" "nomad_client" {
  count = 3
  name  = "nomad-client${count.index}"
  image = "nomad-client"

  depends_on = [
    null_resource.nomad_client,
    lxd_container.consul,
  ]

  config = {
    "security.nesting" = true
    "security.privileged" = true
  }

  file {
    source             = "./consul/client.hcl"
    target_file        = "/etc/consul.d/consul.hcl"
    create_directories = true
    mode = "0755"
  }

  file {
    source            = "./nomad/client.hcl"
    target_file        = "/etc/nomad.d/nomad.hcl"
    create_directories = true
    mode = "0755"
  }
}

resource "null_resource" "start_nomad_client" {
  depends_on = [ lxd_container.nomad_client ]

  for_each = toset(lxd_container.nomad_client[*].name)

  provisioner "local-exec" {
    command = "lxc exec ${each.key} -- service consul start --enable"
  }

  provisioner "local-exec" {
    command = "lxc exec ${each.key} -- service nomad start --enable"
  }

  provisioner "local-exec" {
    command = "lxc exec ${each.key} -- service docker start --enable"
  }
}
