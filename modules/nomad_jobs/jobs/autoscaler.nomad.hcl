variable "version" {
  type    = string
  default = "0.4"
}

# variable "promtail_version" {
#   type    = string
#   default = "2.9.1"
# }

job "autoscaler" {
  type      = "service"
  node_pool = "all"
  namespace = "system"

  group "autoscaler" {
    count = 3

    network {
      mode = "bridge"

      port "http" {}
      // port "promtail" {}
    }

    service {
      name = "autoscaler"
      port = "http"
      task = "autoscaler"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "prometheus"
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

      check {
        type     = "http"
        path     = "/v1/health"
        interval = "3s"
        timeout  = "1s"
      }
    }

    # service {
    #   name = "autoscaler-promtail"
    #   port = "promtail"
    #   task = "promtail"
    #
    #   connect {
    #     sidecar_service {
    #       proxy {
    #         upstreams {
    #           destination_name = "loki"
    #           local_bind_port  = 3100
    #         }
    #       }
    #     }
    #
    #     sidecar_task {
    #       resources {
    #         cpu    = 50
    #         memory = 32
    #       }
    #     }
    #   }
    # }

    task "autoscaler" {
      driver = "docker"

      identity {
        env = true
      }

      config {
        image   = "hashicorp/nomad-autoscaler:${var.version}"
        command = "nomad-autoscaler"
        ports   = ["http"]

        args = [
          "agent",
          "-config",
          "${NOMAD_TASK_DIR}/config.hcl",
          "-http-bind-address",
          "0.0.0.0",
          "-http-bind-port",
          "${NOMAD_PORT_http}",
        ]
      }

      ## Alternatively, you could also run the Autoscaler using the exec driver
      # driver = "exec"
      #
      # config {
      #   command = "/usr/local/bin/nomad-autoscaler"
      #   args    = ["agent", "-config", "${NOMAD_TASK_DIR}/config.hcl"]
      # }
      #
      # artifact {
      #   source      = "https://releases.hashicorp.com/nomad-autoscaler/${var.version}/nomad-autoscaler_${var.version}_linux_amd64.zip"
      #   destination = "/usr/local/bin"
      # }

      resources {
        cpu    = 100
        memory = 128
      }

      template {
        destination = "${NOMAD_TASK_DIR}/config.hcl"

        data = <<-EOT
          nomad {
            address   = "unix:///secrets/api.sock"
            namespace = "*"
          }

          high_availability {
            enabled = true
            lock_namespace = "{{ env "NOMAD_NAMESPACE" }}"
          }

          telemetry {
            prometheus_metrics = true
            disable_hostname   = true
          }

          apm "nomad-apm" {
            driver = "nomad-apm"
          }

          apm "prometheus" {
            driver = "prometheus"
            config = {
              address = "http://{{ env "NOMAD_UPSTREAM_ADDR_prometheus" }}"
            }
          }

          strategy "target-value" {
            driver = "target-value"
          }

          strategy "threshold" {
            driver = "threshold"
          }
        EOT
      }
    }

    # task "promtail" {
    #   driver = "docker"
    #   #   lifecycle {
    #     hook    = "prestart"
    #     sidecar = true
    #   }
    #   #   config {
    #     image = "grafana/promtail:${var.promtail_version}"
    #     ports = ["promtail"]
    #     args = ["-config.file=local/promtail.yaml"]
    #   }
    #   #   resources {
    #     cpu    = 50
    #     memory = 32
    #   }
    #   #   template {
    #     destination = "local/promtail.yaml"
    #   #     data = <<-EOT
    #       server:
    #         http_listen_port: {{ env "NOMAD_PORT_promtail" }}
    #         grpc_listen_port: 0
    #       positions:
    #         filename: /tmp/positions.yaml
    #       client:
    #         url: http://{{ env "NOMAD_UPSTREAM_ADDR_loki" }}/api/prom/push
    #       scrape_configs:
    #       - job_name: system
    #         static_configs:
    #         - targets:
    #             - localhost
    #           labels:
    #             task: autoscaler
    #             __path__: /alloc/logs/autoscaler*
    #         pipeline_stages:
    #         - match:
    #             selector: '{task="autoscaler"}'
    #             stages:
    #             - regex:
    #                 expression: '.*policy_id=(?P<policy_id>[a-zA-Z0-9_-]+).*source=(?P<source>[a-zA-Z0-9_-]+).*strategy=(?P<strategy>[a-zA-Z0-9_-]+).*target=(?P<target>[a-zA-Z0-9_-]+).*Group:(?P<group>[a-zA-Z0-9]+).*Job:(?P<job>[a-zA-Z0-9_-]+).*Namespace:(?P<namespace>[a-zA-Z0-9_-]+)'
    #             - labels:
    #                 policy_id:
    #                 source:
    #                 strategy:
    #                 target:
    #                 group:
    #                 job:
    #                 namespace:
    #     EOT
    #   }
    # }
  }
}
