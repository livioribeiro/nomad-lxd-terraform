job "grafana" {
  datacenters = ["dc1"]

  group "grafana" {
    network {
      port "http" {
        to = 3000
      }
    }

    task "grafana" {
      driver = "docker"

      config {
        image = "grafana/grafana:7.3.6"
        ports = [
          "http"
        ]
      }

      service {
        name = "grafana"
        port = "http"
        tags = ["traefik.enable=true"]
      }
    }
  }
}
