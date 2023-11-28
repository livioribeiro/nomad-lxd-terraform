## deploying autoscaler in "default" namespace
## until https://github.com/hashicorp/terraform-provider-nomad/issues/377
## is solved
# resource "nomad_namespace" "system_autoscaling" {
#   name = "system-autoscaling"
# }

resource "nomad_acl_policy" "nomad_autoscaler" {
  name      = "nomad-autoscaler"

  rules_hcl = <<-EOT
    node {
      policy = "read"
    }
  
    namespace "*" {
      policy = "scale"
    }
  EOT

  job_acl {
    ## see nomad_namespace.system_autoscaling above
    # namespace = nomad_namespace.system_autoscaling.name
    job_id = "autoscaler"
  }
}

resource "nomad_job" "autoscaler" {
  jobspec = file("${path.module}/jobs/autoscaler.nomad.hcl")
  # detach = false

  hcl2 {
    vars = {
      ## see nomad_namespace.system_autoscaling above
      # namespace = nomad_namespace.system_autoscaling.name
      namespace = "default"
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
