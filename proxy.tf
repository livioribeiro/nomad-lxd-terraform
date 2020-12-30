resource "lxd_container" "proxy" {
  name  = "proxy"
  image = lxd_cached_image.ubuntu.fingerprint

  depends_on = [ lxd_container.consul ]

  config = {
    "user.user-data" = format("#cloud-config\n%s", yamlencode({
      apt = {
        sources = {
          "hashicorp.list" = {
            source = "deb [arch=amd64] https://apt.releases.hashicorp.com focal main"
            key = local.hashicorp_gpg
          }
        }
      }
      packages = ["consul"]
      runcmd = [
        "curl -fsSL -o /tmp/traefik.tar.gz ${local.traefik_url}",
        "tar -C /usr/local/bin -xzf /tmp/traefik.tar.gz traefik",
        "mkdir /var/consul",
        "chown -R consul.consul /var/consul/",
        "service consul start --enable",
        "service traefik start --enable",
      ]
    }))
  }

  file {
    source             = "./consul/client.hcl"
    target_file        = "/etc/consul.d/consul.hcl"
    create_directories = true
    mode = "0755"
  }

  file {
    source      = "./proxy/traefik.service"
    target_file = "/etc/systemd/system/traefik.service"
  }

  file {
    source             = "./proxy/traefik.toml"
    target_file        = "/etc/traefik/traefik.toml"
    create_directories = true
    mode = "0755"
  }

  file {
    source             = "./proxy/nomad.toml"
    target_file        = "/etc/traefik/conf/nomad.toml"
    create_directories = true
    mode = "0755"
  }
  
  device {
    name = "proxy-80"
    type = "proxy"
    properties = {
      "listen"  = "tcp:127.0.0.1:80"
      "connect" = "tcp:127.0.0.1:80"
    }
  }
  
  device {
    name = "proxy-8080"
    type = "proxy"
    properties = {
      "listen"  = "tcp:127.0.0.1:8080"
      "connect" = "tcp:127.0.0.1:8080"
    }
  }
}
