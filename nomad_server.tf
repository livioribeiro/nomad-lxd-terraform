resource "lxd_container" "nomad_server" {
  count = 3
  name  = "nomad-server${count.index}"
  image = lxd_cached_image.ubuntu.fingerprint

  depends_on = [ lxd_container.consul ]

  config = {
    "user.user-data" = format("#cloud-config\n%s", yamlencode({
      apt = {
        sources = {
          "hashicorp.list" = {
            source = "deb [arch=amd64] https://apt.releases.hashicorp.com focal main"
            key = local.hashicorp_gpg
          }
        }
      }
      packages = ["consul", "nomad"]
      runcmd = [
        "mkdir /var/consul",
        "chown -R consul.consul /var/consul",
        "mkdir /var/nomad",
        "chown -R nomad.nomad /var/nomad",
        "service consul start --enable",
        "service nomad start --enable",
      ]
    }))
  }

  file {
    source             = "./consul/client.hcl"
    target_file        = "/etc/consul.d/consul.hcl"
    create_directories = true
    mode = "0755"
  }

  file {
    source             = "./nomad/server.hcl"
    target_file        = "/etc/nomad.d/nomad.hcl"
    create_directories = true
    mode = "0755"
  }
}
