packer {
  required_plugins {
    lxd = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/lxd"
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

source "lxd" "consul" {
  image           = "images:ubuntu/${var.ubuntu_version}/cloud"
  container_name  = "packer-consul"
  output_image    = "consul"

  publish_properties = {
    alias       = "consul"
    description = "Consul image"
  }
}

source "lxd" "vault" {
  image           = "images:ubuntu/${var.ubuntu_version}/cloud"
  container_name  = "packer-vault"
  output_image    = "vault"

  publish_properties = {
    alias       = "vault"
    description = "Vault image"
  }
}

source "lxd" "nomad_server" {
  image           = "images:ubuntu/${var.ubuntu_version}/cloud"
  container_name  = "packer-nomad-server"
  output_image    = "nomad-server"

  publish_properties = {
    alias       = "nomad-server"
    description = "Nomad server image"
  }
}

source "lxd" "nomad_client" {
  image           = "images:ubuntu/${var.ubuntu_version}/cloud"
  container_name  = "packer-nomad-client"
  output_image    = "nomad-client"
  virtual_machine = true

  publish_properties = {
    alias       = "nomad-client"
    description = "Nomad client image"
  }
}

build {
  name = "consul"
  sources = ["source.lxd.consul"]

  provisioner "shell" {
    scripts = [
      "provision-base.sh",
      "provision-consul.sh",
    ]
  }
}

build {
  name = "vault"
  sources = ["source.lxd.vault"]

  provisioner "shell" {
    scripts = [
      "provision-base.sh",
      "provision-consul.sh",
      "provision-consul-dns.sh",
    ]
  }

  provisioner "shell" {
    inline = [
      "DEBIAN_FRONTEND=noninteractive apt-get -q -y install vault"
    ]
  }
}

build {
  name = "nomad_server"
  sources = ["source.lxd.nomad_server"]

  provisioner "shell" {
    scripts = [
      "provision-base.sh",
      "provision-consul.sh",
      "provision-consul-dns.sh",
      "provision-nomad-server.sh",
    ]
  }
}

build {
  name = "nomad_client"
  sources = ["source.lxd.nomad_client"]

  provisioner "shell" {
    env = {
      CNI_PLUGINS_VERSION = var.cni_plugins_version
      LOKI_DRIVER_VERSION = var.loki_log_driver_version
    }

    scripts = [
      "provision-base.sh",
      "provision-consul.sh",
      "provision-consul-dns.sh",
      "provision-nomad-client.sh",
    ]
  }
}
