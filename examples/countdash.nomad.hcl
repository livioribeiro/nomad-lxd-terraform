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

      resources {
        cpu    = 50
        memory = 10
      }
    }
  }

  group "dashboard" {
    network {
      mode = "bridge"
    }

    service {
      name = "count-dashboard"
      port = "9002"

      tags = [
        "traefik.enable=true",
        "traefik.consulcatalog.connect=true",
      ]

      connect {
        sidecar_service {
          proxy {
            upstreams {
              service         = "count-api"
              local_bind_port = 9001
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
        COUNTING_SERVICE_URL = "http://localhost:9001"
      }

      resources {
        cpu    = 50
        memory = 30
      }
    }
  }
}