resource "nomad_namespace" "system_autoscaling" {
  name = "system-autoscaling"
}

resource "nomad_acl_policy" "nomad_autoscaler" {
  name        = "nomad-autoscaler"
  description = "Nomad Autoscaler"

  rules_hcl = <<-EOT
    node {
      policy = "read"
    }
  
    namespace "*" {
      policy = "scale"
    }

    namespace "${nomad_namespace.system_autoscaling.name}" {
      policy = "scale"

      variables {
        path "nomad-autoscaler/lock" {
          capabilities = ["read", "write", "destroy"]
        }
      }
    }
  EOT

  job_acl {
    namespace = nomad_namespace.system_autoscaling.name
    job_id    = "autoscaler"
  }
}

resource "nomad_job" "autoscaler" {
  jobspec = file("${path.module}/jobs/autoscaler.nomad.hcl")
  # detach = false

  hcl2 {
    vars = {
      namespace = nomad_namespace.system_autoscaling.name
    }
  }
}

resource "consul_config_entry" "nomad_autoscaler_intention" {
  kind = "service-intentions"
  name = "prometheus"

  config_json = jsonencode({
    Sources = [
      {
        Name   = "autoscaler"
        Action = "allow"
      }
    ]
  })
}
