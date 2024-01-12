resource "nomad_namespace" "system_monitoring" {
  name = "system-monitoring"
}

# Prometheus Consul ACL
resource "consul_acl_policy" "system_monitoring" {
  name  = "system-monitoring"
  rules = <<-EOT
    agent_prefix "" {
      policy = "read"
    }

    node_prefix "" {
      policy = "read"
    }

    service_prefix "" {
      policy = "read"
    }

    service_prefix "prometheus" {
      policy = "write"
    }
  EOT
}

resource "consul_acl_role" "prometheus" {
  name        = "nomad-tasks-${nomad_namespace.system_monitoring.name}"
  description = "prometheus role"

  policies = [
    consul_acl_policy.system_monitoring.id
  ]
}

resource "consul_acl_token" "prometheus" {
  description = "prometheus acl token"
  roles       = [consul_acl_role.prometheus.name]
  local       = true
}

data "consul_acl_token_secret_id" "prometheus" {
  accessor_id = consul_acl_token.prometheus.id
}

resource "nomad_job" "prometheus" {
  depends_on = [nomad_job.docker_registry]

  jobspec = file("${path.module}/jobs/monitoring/prometheus.nomad.hcl")
  # detach = false

  hcl2 {
    vars = {
      namespace = nomad_namespace.system_monitoring.name
      consul_token = data.consul_acl_token_secret_id.prometheus.secret_id
    }
  }
}

resource "nomad_job" "loki" {
  jobspec = file("${path.module}/jobs/monitoring/loki.nomad.hcl")
  # detach = false

  hcl2 {
    vars = {
      namespace = nomad_namespace.system_monitoring.name
    }
  }
}

# Grafana
resource "nomad_job" "grafana" {
  jobspec = file("${path.module}/jobs/monitoring/grafana.nomad.hcl")
  # detach = false

  hcl2 {
    vars = {
      namespace = nomad_namespace.system_monitoring.name
    }
  }
}

resource "consul_config_entry" "prometheus_intention" {
  kind = "service-intentions"
  name = "prometheus"

  config_json = jsonencode({
    Sources = [
      {
        Name   = "grafana"
        Action = "allow"
      },
      {
        Name   = "autoscaler"
        Action = "allow"
      }
    ]
  })
}

resource "consul_config_entry" "loki_intention" {
  kind = "service-intentions"
  name = "loki"

  config_json = jsonencode({
    Sources = [
      {
        Name   = "grafana"
        Action = "allow"
      },
    ]
  })
}
