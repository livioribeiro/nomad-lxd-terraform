data "http" "hashicorp_gpg" {
  url = "https://apt.releases.hashicorp.com/gpg"
}

data "http" "docker_gpg" {
  url = "https://download.docker.com/linux/ubuntu/gpg"
}

data "http" "getenvoy_gpg" {
  url = "https://deb.dl.getenvoy.io/public/gpg.8115BA8E629CC074.key"
}

locals {
  cloudinit_apt_hashicorp = {
    source = "deb [arch=amd64 signed-by=$KEY_FILE] https://apt.releases.hashicorp.com ${var.ubuntu_version} main"
    key    = data.http.hashicorp_gpg.response_body
  }
  cloudinit_apt_docker = {
    source = "deb [arch=amd64 signed-by=$KEY_FILE] https://download.docker.com/linux/ubuntu ${var.ubuntu_version} stable"
    key    = data.http.docker_gpg.response_body
  }
  cloudinit_apt_getenvoy = {
    source = "deb [arch=amd64 signed-by=$KEY_FILE] https://deb.dl.getenvoy.io/public/deb/ubuntu ${var.ubuntu_version} main"
    key    = data.http.getenvoy_gpg.response_body
  }
  cloudinit_consul_dns = {
    path    = "/etc/systemd/resolved.conf.d/consul.conf",
    content = <<-EOT
      [Resolve]
      DNS=127.0.0.1:8600
      DNSSEC=false
      Domains=~consul
    EOT
  }
}