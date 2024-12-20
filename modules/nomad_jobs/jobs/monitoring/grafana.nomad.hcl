variable "version" {
  type    = string
  default = "11.4.0"
}

job "grafana" {
  type      = "service"
  node_pool = "infra"
  namespace = "system"

  group "app" {
    count = 1

    network {
      mode = "bridge"

      port "http" {
        to = 3000
      }

      port "envoy_metrics" {
        to = 9102
      }
    }

    service {
      name = "grafana"
      port = "http"
      tags = ["traefik.enable=true"]

      check {
        name     = "Healthiness Check"
        type     = "http"
        path     = "/robots.txt"
        interval = "10s"
        timeout  = "5s"

        check_restart {
          grace = "10s"
          limit = 5
        }
      }

      check {
        name      = "Readiness Check"
        type      = "http"
        path      = "/robots.txt"
        interval  = "10s"
        timeout   = "5s"
        on_update = "ignore_warnings"

        check_restart {
          grace           = "5s"
          ignore_warnings = true
        }
      }
    }

    service {
      meta {
        envoy_metrics_port = "${NOMAD_HOST_PORT_envoy_metrics}"
      }

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "loki-app"
              local_bind_port  = 3100
            }

            upstreams {
              destination_name = "prometheus-app"
              local_bind_port  = 9090
            }
          }
        }

        sidecar_task {
          resources {
            cpu    = 50
            memory = 32
          }
        }
      }
    }

    task "grafana" {
      driver = "docker"

      config {
        image = "grafana/grafana-oss:${var.version}"
        ports = ["http"]

        mount {
          type     = "bind"
          source   = "local/datasource-loki.yaml"
          target   = "/usr/share/grafana/conf/provisioning/datasources/loki.yaml"
          readonly = true
        }
      }

      resources {
        cpu    = 200
        memory = 256
      }

      template {
        destination = "local/datasource-loki.yaml"
        data        = <<-EOT
          apiVersion: 1
          datasources:
          - name: Loki
            type: loki
            url: http://loki.service.consul:3100
        EOT
      }
    }
  }
}
