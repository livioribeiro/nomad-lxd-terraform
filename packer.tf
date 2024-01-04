data "packer_files" "consul" {
  file              = "./packer/build.pkr.hcl"

  file_dependencies = [
    "./packer/provision-base.sh",
    "./packer/provision-consul.sh",
  ]
}

resource "packer_image" "consul" {
  directory = "./packer"
  additional_params = ["-only=consul.lxd.consul"]

  triggers  = {
    packer = data.packer_files.consul.files_hash
  }

  provisioner "local-exec" {
    when    = destroy
    command = "lxc image delete local:consul"
  }
}

data "packer_files" "vault" {
  file              = "./packer/build.pkr.hcl"

  file_dependencies = [
    "./packer/provision-base.sh",
    "./packer/provision-consul.sh",
    "./packer/provision-consul-dns.sh",
  ]
}

resource "packer_image" "vault" {
  directory = "./packer"
  additional_params = ["-only=vault.lxd.vault"]

  triggers  = {
    packer = data.packer_files.vault.files_hash
  }

  provisioner "local-exec" {
    when    = destroy
    command = "lxc image delete local:vault"
  }
}

data "packer_files" "nomad_server" {
  directory         = "./packer"
  file              = "./packer/build.pkr.hcl"

  file_dependencies = [
    "./packer/provision-base.sh",
    "./packer/provision-consul.sh",
    "./packer/provision-consul-dns.sh",
    "./packer/provision-nomad-server.sh",
  ]
}

resource "packer_image" "nomad_server" {
  directory = "./packer"
  additional_params = ["-only=nomad_server.lxd.nomad_server"]

  triggers  = {
    packer = data.packer_files.nomad_server.files_hash
  }

  provisioner "local-exec" {
    when    = destroy
    command = "lxc image delete local:nomad-server"
  }
}

data "packer_files" "nomad_client" {
  file              = "./packer/build.pkr.hcl"

  file_dependencies = [
    "./packer/provision-base.sh",
    "./packer/provision-consul.sh",
    "./packer/provision-consul-dns.sh",
    "./packer/provision-nomad-client.sh",
  ]
}

resource "packer_image" "nomad_client" {
  directory = "./packer"
  additional_params = ["-only=nomad_client.lxd.nomad_client"]

  triggers  = {
    packer = data.packer_files.nomad_client.files_hash
  }

  provisioner "local-exec" {
    when    = destroy
    command = "lxc image delete local:nomad-client"
  }
}