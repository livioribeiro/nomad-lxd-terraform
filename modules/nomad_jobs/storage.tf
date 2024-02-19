resource "nomad_job" "rocketduck_nfs_controller" {
  depends_on = [nomad_namespace.system]

  jobspec = file("${path.module}/jobs/rocketduck-nfs/controller.nomad.hcl")
  detach  = false

  hcl2 {
    vars = {
      nfs_server_host = var.nfs_server_host
    }
  }
}

resource "nomad_job" "rocketduck_nfs_node" {
  depends_on = [nomad_namespace.system]

  jobspec = file("${path.module}/jobs/rocketduck-nfs/node.nomad.hcl")
  detach  = false

  hcl2 {
    vars = {
      nfs_server_host = var.nfs_server_host
    }
  }
}

data "nomad_plugin" "nfs" {
  depends_on = [
    nomad_job.rocketduck_nfs_controller,
    nomad_job.rocketduck_nfs_node,
  ]

  plugin_id        = "nfs"
  wait_for_healthy = true
}
