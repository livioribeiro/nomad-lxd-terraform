data_dir = "/opt/nomad/data"

client {
  enabled           = true
  network_interface = "eth0"
  node_pool         = "${node_pool}"

  host_volume "docker-socket" {
    path      = "/run/docker.sock"
    read_only = true
  }
}

acl {
  enabled = true
}

tls {
  http      = true
  rpc       = true

  ca_file   = "/etc/certs.d/ca.pem"
  cert_file = "/etc/certs.d/cert.pem"
  key_file  = "/etc/certs.d/key.pem"

  verify_server_hostname = true
  verify_https_client    = true
}

consul {
  token = "${consul_token}"
}

telemetry {
  prometheus_metrics         = true
  disable_hostname           = true
  publish_allocation_metrics = true
  publish_node_metrics       = true
}

plugin "docker" {
  config {
    allow_privileged = true
    extra_labels = ["job_name", "job_id", "task_group_name", "task_name", "namespace", "node_name", "node_id"]
    logging {
      type = "loki"
      config {
        labels           = "com.hashicorp.nomad.job_name,com.hashicorp.nomad.job_id,com.hashicorp.nomad.task_group_name,com.hashicorp.nomad.task_name,com.hashicorp.nomad.namespace,com.hashicorp.nomad.node_name,com.hashicorp.nomad.node_id"
        loki-url         = "http://loki.service.consul:3100/loki/api/v1/push"
        loki-retries     = 2
        loki-max-backoff = "800ms"
        loki-timeout     = "1s"
        loki-batch-size  = 400
        keep-file        = true
        max-size         = "10m"

        loki-relabel-config = <<-EOT
          - action: labelmap
            regex: com_hashicorp_(\w+)
        EOT

        loki-pipeline-stages = <<-EOT
          - decolorize:
          - regex:
              expression: '(level|lvl|severity)=(?P<level>\w+)'
          - labels:
              level:
          - labeldrop:
              - filename
              - host
              - com_hashicorp_nomad_alloc_id
              - com_hashicorp_nomad_job_name
              - com_hashicorp_nomad_job_id
              - com_hashicorp_nomad_task_group_name
              - com_hashicorp_nomad_task_name
              - com_hashicorp_nomad_namespace
              - com_hashicorp_nomad_node_name
              - com_hashicorp_nomad_node_id
        EOT
      }
    }
  }
}