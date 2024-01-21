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

    namespace "${nomad_namespace.system.name}" {
      variables {
        path "nomad-autoscaler/lock" {
          capabilities = ["read", "write", "destroy"]
        }
      }
    }
  EOT

  job_acl {
    namespace = nomad_namespace.system.name
    job_id    = "autoscaler"
  }
}

# the autoscaler lock will prevent terraform from destroying
# the namespace, so we explicitly declare the lock variable
# to allow terraform to manage it.
resource "nomad_variable" "autoscaler_lock" {
  path      = "nomad-autoscaler/lock"
  namespace = nomad_namespace.system.name

  items = {
    # bogus value just to allow the creation of the variable
    lock = "lock"
  }

  lifecycle {
    # ignore changes to the `items` value, so later executions
    # of `terraform apply` do not fail
    ignore_changes = [items]
  }
}

resource "nomad_job" "autoscaler" {
  depends_on = [
    nomad_job.docker_registry,
    nomad_acl_policy.nomad_autoscaler,
    nomad_variable.autoscaler_lock,
  ]

  jobspec = file("${path.module}/jobs/autoscaler.nomad.hcl")
  # detach = false
}

# resource "consul_config_entry" "nomad_autoscaler_intention" {
#   kind = "service-intentions"
#   name = "prometheus"

#   config_json = jsonencode({
#     Sources = [
#       {
#         Name   = "autoscaler"
#         Action = "allow"
#       }
#     ]
#   })
# }
