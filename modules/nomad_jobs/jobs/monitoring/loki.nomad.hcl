variable "version" {
  type    = string
  default = "3.2.2"
}

job "loki" {
  type      = "service"
  node_pool = "infra"
  namespace = "system"

  group "app" {
    count = 1

    network {
      mode = "bridge"

      port "envoy_metrics" {
        to = 9102
      }
    }

    service {
      port = "3100"

      check {
        type     = "http"
        path     = "/ready"
        expose   = true
        interval = "10s"
        timeout  = "5s"

        check_restart {
          grace = "10s"
          limit = 5
        }
      }

      meta {
        envoy_metrics_port = "${NOMAD_HOST_PORT_envoy_metrics}"
      }

      connect {
        sidecar_service {}

        sidecar_task {
          resources {
            cpu    = 50
            memory = 32
          }
        }
      }
    }

    task "loki" {
      driver = "docker"

      config {
        image = "grafana/loki:${var.version}"
        args  = ["-config.file=/local/loki.yaml"]
      }

      resources {
        cpu    = 200
        memory = 256
      }

      template {
        destination   = "local/loki.yaml"
        change_mode   = "signal"
        change_signal = "SIGHUP"

        data = <<-EOT
          auth_enabled: false

          server:
            http_listen_port: 3100

          common:
            ring:
              instance_addr: 127.0.0.1
              kvstore:
                store: inmemory
            replication_factor: 1
            path_prefix: /tmp/loki
            storage:
              filesystem:
                chunks_directory: /tmp/loki/chunks
                rules_directory: /tmp/loki/rules

          ingester:
            lifecycler:
              address: 127.0.0.1
              ring:
                kvstore:
                  store: inmemory
                replication_factor: 1
              final_sleep: 0s
            chunk_idle_period: 5m
            chunk_retain_period: 30s
            wal:
              dir: /loki/wal

          query_range:
            align_queries_with_step: true
            max_retries: 5
            cache_results: true

            results_cache:
              cache:
                embedded_cache:
                  enabled: true
                  max_size_mb: 100

          schema_config:
            configs:
              - from: "2023-01-05"
                store: tsdb
                object_store: filesystem
                schema: v13
                index:
                  prefix: index_
                  period: 24h

          storage_config:
            tsdb_shipper:
              active_index_directory: /loki/tsdb-index
              cache_location: /loki/tsdb-cache
            filesystem:
              directory: /loki/chunks
        EOT
      }
    }
  }
}
