resource "lxd_container" "nomad_client" {
  count = 3
  name  = "nomad-client${count.index}"
  image = lxd_cached_image.ubuntu.fingerprint

  depends_on = [ lxd_container.consul ]

  config = {
    "security.nesting" = "true"
    "security.privileged" = "true"
    "user.user-data" = format("#cloud-config\n%s", yamlencode({
      apt = {
        sources = {
          "hashicorp.list" = {
            source = "deb [arch=amd64] https://apt.releases.hashicorp.com focal main"
            key = local.hashicorp_gpg
          }
          "envoy.list" = {
            source = "deb [arch=amd64] https://dl.bintray.com/tetrate/getenvoy-deb focal stable"
            key = local.envoy_gpg
          }
          "docker.list" = {
            source = "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
            key = local.docker_gpg
          }
        }
      }
      packages = ["consul", "nomad", "getenvoy-envoy", "docker-ce"]
      runcmd = [
        "curl -sL -o /tmp/cni-plugins.tgz ${local.cni_plugins_url}",
        "mkdir -p /opt/cni/bin/",
        "tar -xzf /tmp/cni-plugins.tgz -C /opt/cni/bin/",
        "chmod -R +x /opt/cni/bin/",
        "mkdir /var/consul",
        "chown -R consul.consul /var/consul",
        "mkdir /var/nomad",
        "chown -R nomad.nomad /var/nomad",
        "service docker start --enable",
        "service consul start --enable",
        "service nomad start --enable",
      ]
    }))
  }

  file {
    source            = "./consul/client.hcl"
    target_file        = "/etc/consul.d/consul.hcl"
    create_directories = true
    mode = "0755"
  }

  file {
    source            = "./nomad/client.hcl"
    target_file        = "/etc/nomad.d/nomad.hcl"
    create_directories = true
    mode = "0755"
  }
}
