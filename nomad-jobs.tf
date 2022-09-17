resource "nomad_namespace" "system" {
  depends_on = [
    null_resource.run_ansible
  ]

  for_each = {
    "system-gateway"     = "Cluster Ingress"
    "system-storage"     = "CSI Plugins"
    "system-monitoring"  = "Prometheus"
    "system-autoscaling" = "Nomad Autoscaling"
    "system-registry"    = "Docker Registry"
  }
  name        = each.key
  description = each.value
}

resource "nomad_job" "app" {
  depends_on = [
    nomad_namespace.system
  ]

  for_each = toset([
    "proxy",
    "docker-registry",
    "prometheus",
    "autoscaler",
    "rocketduck-nfs/controller",
    "rocketduck-nfs/node",
  ])

  jobspec = file("${path.module}/nomad_jobs/${each.key}.nomad")

  hcl2 {
    enabled = true
  }
}