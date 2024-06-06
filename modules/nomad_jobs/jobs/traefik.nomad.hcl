variable "version" {
  type    = string
  default = "v3.0"
}

variable "proxy_suffix" {
  type    = string
  default = "apps.localhost"
}

job "traefik" {
  type      = "system"
  node_pool = "infra"
  namespace = "system"

  group "traefik" {
    network {
      port "ingress" {
        static = 80
      }

      port "dashboard" {
        static = 8080
      }
    }

    service {
      name = "traefik-dashboard"
      port = "dashboard"

      check {
        name     = "alive"
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "traefik" {
      driver = "docker"

      config {
        image        = "traefik:${var.version}"
        network_mode = "host"

        volumes = [
          "local/traefik.yaml:/etc/traefik/traefik.yaml",
        ]
      }

      resources {
        cpu    = 100
        memory = 128
      }

      identity {
        name          = "consul_default"
        aud           = ["consul.io"]
        ttl           = "24h"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }

      template {
        destination     = "local/traefik.yaml"
        left_delimiter  = "[["
        right_delimiter = "]]"
        data            = <<-EOF
          log:
            level: INFO

          entryPoints:
            http:
              address: ":80"
              forwardedHeaders:
                insecure: true

          accessLog:
            filePath: /var/log/traefik/access.log

          api:
            dashboard: true
            insecure: true
            debug: true

          metrics:
            prometheus: {}

          providers:
            consulCatalog:
              endpoint:
                address: '127.0.0.1:8500'
                token: "[[ env "CONSUL_TOKEN" ]]"
              exposedByDefault: false
              defaultRule: "Host(`{{ normalize .Name }}.${var.proxy_suffix}`)"
        EOF
      }
    }
  }
}