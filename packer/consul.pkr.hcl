locals {
  ubuntu_version = "focal"
}

source "lxd" "consul" {
  image        = "local:base"
  output_image = "consul"
  publish_properties = {
    description = "Consul image"
  }
}

build {
  sources = ["source.lxd.consul"]

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1",
    ]
    inline = [
      "curl -fsSL https://apt.releases.hashicorp.com/gpg -o /tmp/hashicorp.gpg",
      "apt-key add /tmp/hashicorp.gpg",
      "apt-add-repository 'deb [arch=amd64] https://apt.releases.hashicorp.com focal main'",
      "apt-get update -q",
      "apt-get install -q -y consul",
      "mkdir /var/consul",
      "chown -R consul:consul /var/consul",
    ]
  }
}
