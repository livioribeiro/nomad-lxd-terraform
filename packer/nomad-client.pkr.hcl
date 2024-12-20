packer {
  required_plugins {
    lxd = {
      source  = "github.com/hashicorp/lxd"
      version = "~> 1"
    }
  }
}

variable "ubuntu_version" {
  type    = string
  default = "noble"
}

variable "cni_plugins_version" {
  type    = string
  default = "1.5.0"
}

variable "consul_cni_version" {
  type    = string
  default = "1.4.3"
}

variable "loki_log_driver_version" {
  type    = string
  default = "3.0.0"
}

source "lxd" "nomad-client" {
  image           = "ubuntu:${var.ubuntu_version}"
  container_name  = "packer-nomad-client"
  output_image    = "nomad-client"
  virtual_machine = true
  init_sleep      = 10

  publish_properties = {
    alias       = "nomad-client"
    description = "Nomad Client image"
  }
}

build {
  sources = ["lxd.nomad-client"]

  provisioner "shell" {
    env = {
      GPG_HASHICORP       = "https://apt.releases.hashicorp.com/gpg"
      APT_HASHICORP       = "https://apt.releases.hashicorp.com"
      GPG_DOCKER          = "https://download.docker.com/linux/ubuntu/gpg"
      APT_DOCKER          = "https://download.docker.com/linux/ubuntu"
      GPG_ENVOY        = "https://apt.envoyproxy.io/signing.key"
      APT_ENVOY        = "https://apt.envoyproxy.io"
      CNI_PLUGINS_URL     = "https://github.com/containernetworking/plugins/releases/download/v${var.cni_plugins_version}/cni-plugins-linux-amd64-v${var.cni_plugins_version}.tgz"
      CONSUL_CNI_URL      = "https://releases.hashicorp.com/consul-cni/${var.consul_cni_version}/consul-cni_${var.consul_cni_version}_linux_amd64.zip"
      LOKI_DRIVER_VERSION = var.loki_log_driver_version
    }

    script = "provision-nomad-client.sh"
  }
}
