job "hello-world" {
  group "example" {
    # 3 replicas
    count = 3

    network {
      # require a random port named "http"
      port "http" {
        to = 8080
      }
    }

    task "server" {
      # we will run a docker container
      driver = "docker"

      config {
        # docker image to run
        image = "hashicorp/http-echo"
        args = [
          "-listen", ":${NOMAD_PORT_http}", # reference the random port
          "-text", "hello world",
        ]
        # expose ports to the container
        ports = [
          "http"
        ]
      }

      resources {
        cpu    = 50
        memory = 30
      }
    }
  }
}
