job "countdash" {
  group "api" {
    network {
      mode = "bridge"
    }

    service {
      name = "count-api"
      port = "9001"

      connect {
        sidecar_service {}

        sidecar_task {
          resources {
            cpu    = 25
            memory = 30
          }
        }
      }
    }

    task "api" {
      driver = "docker"

      config {
        image = "hashicorpnomad/counter-api:v3"
      }

      env {
        PORT = "9001"
      }

      resources {
        cpu    = 50
        memory = 10
      }
    }
  }

  group "dashboard" {
    network {
      mode = "bridge"

      port "http" {}
    }

    service {
      name = "count-dashboard"
      port = "http"

      tags = ["traefik.enable=true"]

      connect {
        sidecar_service {
          tags = ["traefik.enable=false"]

          proxy {
            upstreams {
              destination_name = "count-api"
              local_bind_port = 8080
            }
          }
        }
        sidecar_task {
          resources {
            cpu    = 50
            memory = 30
          }
        }
      }
    }

    task "dashboard" {
      driver = "docker"

      config {
        image = "hashicorpnomad/counter-dashboard:v3"
      }

      env {
        PORT = "${NOMAD_PORT_http}"
        COUNTING_SERVICE_URL = "http://${NOMAD_UPSTREAM_ADDR_count_api}"
      }

      resources {
        cpu    = 50
        memory = 30
      }
    }
  }
}