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
  default = "jammy"
}

variable "cni_plugins_version" {
  type    = string
  default = "1.4.0"
}

variable "loki_log_driver_version" {
  type    = string
  default = "2.9.3"
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
      GPG_GETENVOY        = "https://deb.dl.getenvoy.io/public/gpg.8115BA8E629CC074.key"
      APT_GETENVOY        = "https://deb.dl.getenvoy.io/public/deb/ubuntu"
      CNI_PLUGINS_URL     = "https://github.com/containernetworking/plugins/releases/download/v${var.cni_plugins_version}/cni-plugins-linux-amd64-v${var.cni_plugins_version}.tgz"
      LOKI_DRIVER_VERSION = var.loki_log_driver_version
    }

    script = "provision-nomad-client.sh"
  }
}