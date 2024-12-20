variable "version" {
  type    = string
  default = "v3.0.1"
}

job "prometheus" {
  type      = "service"
  node_pool = "infra"
  namespace = "system"

  group "app" {
    count = 1

    restart {
      attempts = 2
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }

    network {
      mode = "bridge"

      port "prometheus" {
        to = 9090
      }

      port "envoy_metrics" {
        to = 9102
      }
    }

    service {
      name = "prometheus"
      port = "prometheus"
      tags = ["traefik.enable=true"]

      check {
        type     = "http"
        port     = "prometheus"
        path     = "/-/healthy"
        interval = "10s"
        timeout  = "2s"
      }
    }

    service {
      port = "9090"

      check {
        type     = "http"
        port     = "prometheus"
        path     = "/-/healthy"
        interval = "10s"
        timeout  = "2s"
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

    task "prometheus" {
      driver = "docker"

      config {
        image = "prom/prometheus:${var.version}"
        ports = ["prometheus"]

        volumes = [
          "local/prometheus.yml:/etc/prometheus/prometheus.yml",
        ]
      }

      env {
        CONSUL_ADDR = "${attr.unique.network.ip-address}:8500"
      }

      identity {
        name          = "consul_default"
        aud           = ["consul.io"]
        ttl           = "24h"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }

      vault {}

      template {
        destination = "${NOMAD_SECRETS_DIR}/ca.pem"
        data        = <<-EOT
          {{ with secret "pki/issue/nomad-cluster" "ttl=24h" "format=pem_bundle" }}
          {{- .Data.issuing_ca -}}
          {{ end }}
        EOT
      }

      template {
        destination = "${NOMAD_SECRETS_DIR}/cert.pem"
        data        = <<-EOT
          {{ with secret "pki/issue/nomad-cluster" "ttl=24h" "format=pem_bundle" }}
          {{- .Data.certificate -}}
          {{ end }}
        EOT
      }

      template {
        destination = "${NOMAD_SECRETS_DIR}/key.pem"
        data        = <<-EOT
          {{ with secret "pki/issue/nomad-cluster" "ttl=24h" "format=pem_bundle" }}
          {{- .Data.private_key -}}
          {{ end }}
        EOT
      }

      template {
        destination = "local/prometheus.yml"
        change_mode = "restart"
        data        = <<-EOT
          # Source:
          # https://learn.hashicorp.com/tutorials/nomad/prometheus-metrics
          ---

          global:
            scrape_interval:     5s
            evaluation_interval: 5s

          scrape_configs:
          # CONSUL
          - job_name: consul_metrics
            consul_sd_configs:
            - server: '{{ env "attr.unique.network.ip-address" }}:8500'
              token: '{{ env "CONSUL_TOKEN" }}'
              services: [consul]

            tls_config:
              insecure_skip_verify: true
              ca_file: {{ env "NOMAD_SECRETS_DIR" }}/ca.pem
              cert_file: {{ env "NOMAD_SECRETS_DIR" }}/cert.pem
              key_file: {{ env "NOMAD_SECRETS_DIR" }}/key.pem

            scrape_interval: 5s
            metrics_path: /v1/agent/metrics
            scheme: https
            params:
              format: [prometheus]

            relabel_configs:
            - source_labels: [__address__]
              regex: '(.+):8300'
              target_label: __address__
              replacement: $${1}:8501

          # VAULT
          - job_name: vault_metrics
            consul_sd_configs:
            - server: '{{ env "attr.unique.network.ip-address" }}:8500'
              token: '{{ env "CONSUL_TOKEN" }}'
              services: [vault]
              # tags: [active]

            scrape_interval: 5s
            metrics_path: /v1/sys/metrics
            scheme: https
            params:
              format: [prometheus]

            tls_config:
              insecure_skip_verify: true

          # NOMAD
          - job_name: nomad_metrics
            consul_sd_configs:
            - server: '{{ env "attr.unique.network.ip-address" }}:8500'
              token: '{{ env "CONSUL_TOKEN" }}'
              services: [nomad-client, nomad]

            tls_config:
              insecure_skip_verify: true
              ca_file: {{ env "NOMAD_SECRETS_DIR" }}/ca.pem
              cert_file: {{ env "NOMAD_SECRETS_DIR" }}/cert.pem
              key_file: {{ env "NOMAD_SECRETS_DIR" }}/key.pem

            relabel_configs:
            - action: keep
              source_labels: ['__meta_consul_tags']
              regex: '(.*)http(.*)'
            - action: labelmap
              regex: exported_job
              replacement: job_name

            scrape_interval: 5s
            metrics_path: /v1/metrics
            scheme: https
            params:
              format: [prometheus]

          # NOMAD AUTOSCALER
          - job_name: nomad_autoscaler
            consul_sd_configs:
            - server: '{{ env "attr.unique.network.ip-address" }}:8500'
              token: '{{ env "CONSUL_TOKEN" }}'
              services: [autoscaler]

            scrape_interval: 5s
            metrics_path: /v1/metrics
            params:
              format: [prometheus]

          # PROXY/TRAEFIK
          - job_name: traefik_metrics
            consul_sd_configs:
            - server: '{{ env "attr.unique.network.ip-address" }}:8500'
              token: '{{ env "CONSUL_TOKEN" }}'
              services: [traefik]

          # CONSUL CONNECT ENVOY
          # https://www.mattmoriarity.com/2021-02-21-scraping-prometheus-metrics-with-nomad-and-consul-connect/
          - job_name: consul_connect_envoy_metrics
            consul_sd_configs:
              - server: '{{ env "attr.unique.network.ip-address" }}:8500'
                token: '{{ env "CONSUL_TOKEN" }}'

            relabel_configs:
            - source_labels: [__meta_consul_service]
              action: drop
              regex: (.+)-sidecar-proxy
            - source_labels: [__meta_consul_service_metadata_envoy_metrics_port]
              action: keep
              regex: (.+)
            - source_labels: [__address__, __meta_consul_service_metadata_envoy_metrics_port]
              regex: ([^:]+)(?::\d+)?;(\d+)
              replacement: $${1}:$${2}
              target_label: __address__
        EOT
      }
    }
  }
}
