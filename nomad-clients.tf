resource "lxd_container" "nomad_infra_client" {
  count    = 2
  name     = "nomad-infra-client${count.index}"
  image    = "images:ubuntu/jammy/cloud"

  limits = {
    cpu    = 1
    memory = "3GB"
  }

  config = {
    "user.user-data"      = local.cloud_init
    "security.nesting"    = true
    "security.privileged" = true
    "raw.lxc" = <<-EOF
      lxc.apparmor.profile=unconfined
      lxc.cgroup.devices.allow=a
      lxc.cap.drop=
    EOF
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.nomad_cluster.private_key_pem
    host        = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = ["echo 1"]
  }
}

resource "lxd_container" "nomad_apps_client" {
  count    = 3
  name     = "nomad-apps-client${count.index}"
  image    = "images:ubuntu/jammy/cloud"

  limits = {
    cpu    = 1
    memory = "3GB"
  }

  config = {
    "user.user-data"      = local.cloud_init
    "security.nesting"    = true
    "security.privileged" = true
    "raw.lxc" = <<-EOF
      lxc.apparmor.profile=unconfined
      lxc.cgroup.devices.allow=a
      lxc.cap.drop=
    EOF
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.nomad_cluster.private_key_pem
    host        = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = ["echo 1"]
  }
}