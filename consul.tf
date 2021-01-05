data "null_data_source" "consul" {
  inputs = {
    source = filesha256("packer/consul.pkr.hcl")
  }
}

resource "null_resource" "consul" {
  depends_on = [ null_resource.base ]

  triggers = {
    source_hash = data.null_data_source.consul.outputs.source
  }

  provisioner "local-exec" {
    command = "packer build consul.pkr.hcl"
    working_dir = "packer"
  }
}

resource "lxd_container" "consul" {
  count = 3
  name  = "consul${count.index}"
  image = "consul"

  depends_on = [
    null_resource.consul,
  ]

  file {
    content            = templatefile("./consul/server.hcl.tpl", { instance = count.index })
    target_file        = "/etc/consul.d/consul.hcl"
    create_directories = true
    mode = "0755"
  }
}

resource "null_resource" "start_consul" {
  depends_on = [ lxd_container.consul ]

  for_each = toset(lxd_container.consul[*].name)

  provisioner "local-exec" {
    command = "lxc exec ${each.key} -- service consul start --enable"
  }
}
