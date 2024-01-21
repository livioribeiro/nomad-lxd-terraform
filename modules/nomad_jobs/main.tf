resource "nomad_namespace" "system" {
  name        = "system"
  description = "Namespace key services of the cluster"
}

data "nomad_namespace" "default" {
  name = "default"
}