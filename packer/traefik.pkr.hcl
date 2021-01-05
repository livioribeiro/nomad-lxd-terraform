variable "traefik_version" {
  type = string
  default = "2.3.6"
}

locals {
  traefik_url = "https://github.com/traefik/traefik/releases/download/v${var.traefik_version}/traefik_v${var.traefik_version}_linux_amd64.tar.gz"
}

source "lxd" "traefik" {
  image        = "local:consul"
  output_image = "traefik"
  publish_properties = {
    description = "Traefik image"
  }
}

build {
  sources = ["source.lxd.traefik"]

  provisioner "file" {
    source = "traefik.service"
    destination = "/etc/systemd/system/traefik.service"
  }

  provisioner "shell" {
    inline = [
      "curl -fsSL -o /tmp/traefik.tar.gz ${local.traefik_url}",
      "tar -C /usr/local/bin -xzf /tmp/traefik.tar.gz traefik",
      "mkdir -p /etc/traefik/conf",
    ]
  }
}
