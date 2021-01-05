source "lxd" "base" {
  image        = "images:ubuntu/focal/amd64"
  output_image = "base"
  publish_properties = {
    description = "Base image for Nomad cluster"
  }
}

build {
  sources = ["source.lxd.base"]

  provisioner "shell" {
    inline = [
      "apt-get install -q -y apt-transport-https ca-certificates curl gpg-agent software-properties-common",
    ]
  }
}
