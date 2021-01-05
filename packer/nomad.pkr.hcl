source "lxd" "nomad" {
  image        = "local:consul"
  output_image = "nomad"
  publish_properties = {
    description = "Nomad base image"
  }
}

build {
  sources = ["source.lxd.nomad"]

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
    ]
    inline = [
      "apt-get update -q",
      "apt-get install -q -y nomad",
      "mkdir /var/nomad",
      "chown -R nomad:nomad /var/nomad",
    ]
  }
}
