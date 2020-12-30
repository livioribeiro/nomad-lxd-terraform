resource "lxd_container" "consul" {
  count = 3
  name  = "consul${count.index}"
  image = lxd_cached_image.ubuntu.fingerprint

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
      packages = ["consul"]
      runcmd = [
        "mkdir /var/consul",
        "chown -R consul.consul /var/consul",
        "service consul start --enable",
      ]
    }))
  }

  file {
    content            = templatefile("./consul/server.hcl.tpl", { instance = count.index })
    target_file        = "/etc/consul.d/consul.hcl"
    create_directories = true
    mode = "0755"
  }
}
