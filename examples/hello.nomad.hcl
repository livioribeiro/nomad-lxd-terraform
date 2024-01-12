job "hello-world" {
  group "example" {
    # 3 replicas
    count = 3

    network {
      mode = "bridge"
      # require a random port named "http"
      port "http" {
        to = 8080
      }
    }

    service {
      name = "hello-world"
      port = "8080"
      tags = [
        "traefik.enable=true",
        "traefik.consulcatalog.connect=true",
      ]

      connect {
        sidecar_service {}
      }
    }

    task "server" {
      # we will run a docker container
      driver = "docker"

      config {
        # docker image to run
        image = "hashicorp/http-echo"
        args = [
          "-listen", "127.0.0.1:${NOMAD_PORT_http}", # reference the random port
          "-text", "hello world",
        ]
        # expose ports to the container
        // ports = [
        //   "http"
        // ]
      }

      resources {
        cpu    = 50
        memory = 30
      }

      # # exposed service
      # service {
      #   # service name, compose the url like 'hello-world.service.myorg.com'
      #   name = "hello-world"
      #   # service will bind to this port
      #   port = "http"
      #   # tell traefik to expose this service
      #   tags = ["traefik.enable=true"]
      # }
    }
  }
}
