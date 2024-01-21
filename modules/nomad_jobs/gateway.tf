# Traefik Consul ACL
resource "consul_acl_policy" "system_gateway_traefik" {
  name  = "${nomad_namespace.system.name}-traefik"
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
  name        = "nomad-tasks-${nomad_namespace.system.name}-traefik"
  description = "Traefik role"

  policies = [
    consul_acl_policy.system_gateway_traefik.id,
  ]
}

resource "consul_acl_token" "traefik" {
  description = "Traefik acl token"
  roles       = [consul_acl_role.traefik.name]
  local       = true
}

data "consul_acl_token_secret_id" "traefik" {
  accessor_id = consul_acl_token.traefik.id
}

resource "nomad_job" "proxy" {
  depends_on = [nomad_job.docker_registry]

  jobspec = file("${path.module}/jobs/traefik.nomad.hcl")
  # detach = false

  hcl2 {
    vars = {
      proxy_suffix = "${var.apps_subdomain}.${var.external_domain}"
    }
  }
}