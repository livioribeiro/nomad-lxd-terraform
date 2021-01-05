variable "cni_plugins_version" {
  type = string
  default = "0.9.0"
}

locals {
  cni_plugins_url = "https://github.com/containernetworking/plugins/releases/download/v${var.cni_plugins_version}/cni-plugins-linux-amd64-v${var.cni_plugins_version}.tgz"
}

source "lxd" "nomad-client" {
  image        = "local:nomad"
  output_image = "nomad-client"
  publish_properties = {
    description = "Nomad client image"
  }
}

build {
  sources = ["source.lxd.nomad-client"]

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1",
    ]
    inline = [
      # install docker
      "curl -fsSL -o /tmp/docker.gpg https://download.docker.com/linux/ubuntu/gpg",
      "apt-key add /tmp/docker.gpg",
      "apt-add-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable'",
      "apt-get update -q",
      "apt-get install -q -y docker-ce docker-ce-cli containerd.io",
      
      # install openjdk
      # "apt-get install -q -y openjdk-11-jdk-headless",

      # install envoy
      "curl -fsSL -o /tmp/envoy.gpg https://getenvoy.io/gpg",
      "apt-key add /tmp/envoy.gpg",
      "apt-add-repository 'deb [arch=amd64] https://dl.bintray.com/tetrate/getenvoy-deb focal stable'",
      "apt-get update -q",
      "apt-get install -q -y getenvoy-envoy",

      # install cni plugins
      "curl -fsSL -o /tmp/cni-plugins.tgz ${local.cni_plugins_url}",
      "mkdir -p /opt/cni/bin/",
      "tar -xzf /tmp/cni-plugins.tgz -C /opt/cni/bin/",
      // "chown -R nomad:nomad /opt/cni/bin/",
      // "chmod -R u+x /opt/cni/bin/",
    ]
  }
}
