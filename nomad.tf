data "null_data_source" "nomad" {
  inputs = {
    source = filesha256("packer/nomad.pkr.hcl")
  }
}

resource "null_resource" "nomad" {
  depends_on = [ null_resource.consul ]

  triggers = {
    source_hash = data.null_data_source.nomad.outputs.source
  }

  provisioner "local-exec" {
    command = "packer build nomad.pkr.hcl"
    working_dir = "packer"
  }
}

resource "lxd_container" "nomad" {
  count = 3
  name  = "nomad${count.index}"
  image = "nomad"

  depends_on = [
    null_resource.nomad,
    lxd_container.consul,
  ]

  file {
    source             = "./consul/client.hcl"
    target_file        = "/etc/consul.d/consul.hcl"
    create_directories = true
    mode = "0755"
  }

  file {
    source             = "./nomad/server.hcl"
    target_file        = "/etc/nomad.d/nomad.hcl"
    create_directories = true
    mode = "0755"
  }
}

resource "null_resource" "start_nomad" {
  depends_on = [ lxd_container.nomad ]

  for_each = toset(lxd_container.nomad[*].name)

  provisioner "local-exec" {
    command = "lxc exec ${each.key} -- service consul start --enable"
  }

  provisioner "local-exec" {
    command = "lxc exec ${each.key} -- service nomad start --enable"
  }
}
