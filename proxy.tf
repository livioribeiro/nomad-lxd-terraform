data "null_data_source" "traefik" {
  inputs = {
    source = filesha256("packer/traefik.pkr.hcl")
    service = filesha256("packer/traefik.service")
  }
}

resource "null_resource" "traefik" {
  depends_on = [ null_resource.consul ]

  triggers = {
    source_hash = data.null_data_source.traefik.outputs.source
    service_hash = data.null_data_source.traefik.outputs.service
  }

  provisioner "local-exec" {
    command = "packer build -var 'traefik_version=${var.traefik_version}' traefik.pkr.hcl"
    working_dir = "packer"
  }
}

resource "lxd_container" "proxy" {
  name  = "proxy"
  image = "traefik"

  depends_on = [
    null_resource.traefik,
    lxd_container.consul,
  ]

  file {
    source             = "./consul/client.hcl"
    target_file        = "/etc/consul.d/consul.hcl"
    create_directories = true
    mode = "0755"
  }

  file {
    source             = "./proxy/traefik.yaml"
    target_file        = "/etc/traefik/traefik.yaml"
    create_directories = true
    mode = "0755"
  }

  file {
    source             = "./proxy/nomad.yaml"
    target_file        = "/etc/traefik/conf/nomad.yaml"
    create_directories = true
    mode = "0755"
  }
  
  device {
    name = "proxy-80"
    type = "proxy"
    properties = {
      "listen"  = "tcp:127.0.0.1:80"
      "connect" = "tcp:127.0.0.1:80"
    }
  }
  
  device {
    name = "proxy-8080"
    type = "proxy"
    properties = {
      "listen"  = "tcp:127.0.0.1:8080"
      "connect" = "tcp:127.0.0.1:8080"
    }
  }
}

resource "null_resource" "start_traefik" {
  depends_on = [ lxd_container.proxy ]

  provisioner "local-exec" {
    command = "lxc exec ${lxd_container.proxy.name} -- service consul start --enable"
  }

  provisioner "local-exec" {
    command = "lxc exec ${lxd_container.proxy.name} -- service traefik start --enable"
  }
}