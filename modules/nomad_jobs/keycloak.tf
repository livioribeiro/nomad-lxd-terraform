resource "nomad_csi_volume" "keycloak_database_data" {
  depends_on = [data.nomad_plugin.nfs]

  plugin_id    = "nfs"
  volume_id    = "keycloak-database-data"
  name         = "keycloak-database-data"
  namespace    = data.nomad_namespace.default.name
  capacity_min = "500MiB"
  capacity_max = "750MiB"

  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
}

resource "nomad_job" "keycloak" {
  depends_on = [nomad_job.docker_registry]

  jobspec = file("${path.module}/jobs/keycloak.nomad.hcl")
  # detach = false

  hcl2 {
    vars = {
      volume_name     = nomad_csi_volume.keycloak_database_data.name
      external_domain = var.external_domain
      apps_subdomain  = var.apps_subdomain
      realm_import    = templatefile("${path.module}/keycloak-realm.json.tpl", {
        external_domain = var.external_domain
      })
    }
  }
}

resource "consul_config_entry" "keycloak_intention" {
  kind = "service-intentions"
  name = "keycloak-database"

  config_json = jsonencode({
    Sources = [
      {
        Name   = "keycloak-app"
        Action = "allow"
      }
    ]
  })
}
