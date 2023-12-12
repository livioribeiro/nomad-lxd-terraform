# Traefik Consul ACL
resource "consul_acl_policy" "traefik" {
  name  = "traefik"
  rules = <<-EOT
    node_prefix "" {
      policy = "read"
    }

    service_prefix "" {
      policy = "read"
    }

    service_prefix "traefik" {
      policy = "write"
    }
  EOT
}
resource "consul_acl_role" "traefik" {
  name        = "nomad-${nomad_namespace.system_gateway.name}-tasks"
  description = "Traefik role"

  policies = [
    "${consul_acl_policy.traefik.id}"
  ]
}

resource "nomad_namespace" "system_gateway" {
  name = "system-gateway"
}

resource "nomad_job" "proxy" {
  depends_on = [nomad_job.docker_registry]

  jobspec = file("${path.module}/jobs/traefik.nomad.hcl")
  # detach = false

  hcl2 {
    vars = {
      namespace    = nomad_namespace.system_gateway.name
      proxy_suffix = "${var.apps_subdomain}.${var.external_domain}"
    }
  }
}