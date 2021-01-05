variable "prometheus_version" {
  type = string
  default = "2.23.0"
}

locals {
  prometheus_url = "https://github.com/prometheus/prometheus/releases/download/v${var.prometheus_version}/prometheus-${var.prometheus_version}.linux-amd64.tar.gz"
}

source "lxd" "prometheus" {
  image        = "local:consul"
  output_image = "prometheus"
  publish_properties = {
    description = "Prometheus image"
  }
}

build {
  sources = ["source.lxd.prometheus"]

  provisioner "file" {
    source = "prometheus.service"
    destination = "/etc/systemd/system/prometheus.service"
  }

  provisioner "shell" {
    inline = [
      "curl -fsSL -o /tmp/prometheus.tar.gz ${local.prometheus_url}",
      "tar -C /tmp -xzf /tmp/prometheus.tar.gz prometheus-${var.prometheus_version}.linux-amd64/prometheus",
      "mv /tmp/prometheus-${var.prometheus_version}.linux-amd64/prometheus /usr/local/bin/",
      "mkdir -p /etc/prometheus",
    ]
  }
}
