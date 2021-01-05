data "null_data_source" "prometheus" {
  inputs = {
    source = filesha256("packer/prometheus.pkr.hcl")
    service = filesha256("packer/prometheus.service")
  }
}

resource "null_resource" "prometheus" {
  depends_on = [ null_resource.consul ]

  triggers = {
    source_hash = data.null_data_source.prometheus.outputs.source
    service_hash = data.null_data_source.prometheus.outputs.service
  }

  provisioner "local-exec" {
    command = "packer build -var 'prometheus_version=${var.prometheus_version}' prometheus.pkr.hcl"
    working_dir = "packer"
  }
}

resource "lxd_container" "metrics" {
  name  = "metrics"
  image = "prometheus"

  depends_on = [
    null_resource.prometheus,
    lxd_container.consul,
  ]

  file {
    source             = "./consul/client.hcl"
    target_file        = "/etc/consul.d/consul.hcl"
    create_directories = true
    mode = "0755"
  }

  file {
    source             = "./metrics/prometheus.yml"
    target_file        = "/etc/prometheus/prometheus.yml"
    create_directories = true
    mode = "0755"
  }
}

resource "null_resource" "start_prometheus" {
  depends_on = [ lxd_container.metrics ]

  provisioner "local-exec" {
    command = "lxc exec ${lxd_container.metrics.name} -- service consul start --enable"
  }

  provisioner "local-exec" {
    command = "lxc exec ${lxd_container.metrics.name} -- service prometheus start --enable"
  }
}