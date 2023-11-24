data "http" "docker_gpg" {
  url = "https://download.docker.com/linux/ubuntu/gpg"
}

data "http" "getenvoy_gpg" {
  url = "https://deb.dl.getenvoy.io/public/gpg.8115BA8E629CC074.key"
}

locals {
  nomad_clients = merge(local.nomad_infra_clients, local.nomad_apps_clients)
  nomad_node_pool = merge(
    { for s, _ in local.nomad_infra_clients : s => "infra" },
    { for s, _ in local.nomad_apps_clients : s => "apps" },
  )
  nomad_client_raw_lxc = <<-EOT
    lxc.apparmor.profile=unconfined
    lxc.cgroup.devices.allow=a
    lxc.cap.drop=
  EOT
}

resource "consul_acl_token" "nomad_client_agent" {
  for_each = local.nomad_clients

  node_identities {
    datacenter = "dc1"
    node_name  = each.key
  }
}

data "consul_acl_token_secret_id" "nomad_client_agent" {
  for_each = local.nomad_clients

  accessor_id = consul_acl_token.nomad_client_agent[each.key].id
}

resource "consul_acl_policy" "nomad_client" {
  name  = "nomad-client"
  rules = <<-EOT
    agent_prefix "" {
      policy = "read"
    }

    node_prefix "" {
      policy = "read"
    }

    service_prefix "" {
      policy = "write"
    }

    key_prefix "" {
      policy = "read"
    }
  EOT
}

resource "consul_acl_token" "nomad_client" {
  depends_on = [null_resource.ansible_consul]
  for_each   = local.nomad_clients

  description = "${each.key} client token"
  policies    = [consul_acl_policy.nomad_client.name]
}

data "consul_acl_token_secret_id" "nomad_client" {
  for_each = local.nomad_clients

  accessor_id = consul_acl_token.nomad_client[each.key].id
}

data "cloudinit_config" "nomad_client" {
  for_each = local.nomad_clients

  gzip          = false
  base64_encode = false

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = yamlencode({
      ssh_authorized_keys = [tls_private_key.ssh_nomad_cluster.public_key_openssh]
      apt = {
        sources = {
          hashicorp = {
            source = "deb [arch=amd64 signed-by=$KEY_FILE] https://apt.releases.hashicorp.com ${var.ubuntu_version} main"
            key    = data.http.hashicorp_gpg.response_body
          }
          docker = {
            source = "deb [arch=amd64 signed-by=$KEY_FILE] https://download.docker.com/linux/ubuntu ${var.ubuntu_version} stable"
            key    = data.http.docker_gpg.response_body
          }
          getenvoy = {
            source = "deb [arch=amd64 signed-by=$KEY_FILE] https://deb.dl.getenvoy.io/public/deb/ubuntu ${var.ubuntu_version} main"
            key    = data.http.getenvoy_gpg.response_body
          }
        }
      }
      packages = [
        "openssh-server",
        "consul",
        "nomad",
        "docker-ce",
        "containerd.io",
        "getenvoy-envoy",
        "nfs-common",
      ]
      runcmd = [
        "mkdir -p /opt/cni/bin",
        "wget -q -O /tmp/cni-plugins.tgz https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz",
        "tar -vxf /tmp/cni-plugins.tgz -C /opt/cni/bin",
        "chown root.root /opt/cni/bin",
        "chmod 755 /opt/cni/bin/*",
        "rm /tmp/cni-plugins.tgz",
        "usermod -aG docker nomad",
        "systemctl enable consul nomad docker",
        "systemctl start consul nomad docker",
        "docker plugin install grafana/loki-docker-driver:2.9.2 --alias loki --grant-all-permissions",
        "mount --make-shared /",
      ]
      write_files = [
        { path = "/etc/certs.d/ca.pem", content = tls_self_signed_cert.nomad_cluster.cert_pem },
        { path = "/etc/certs.d/cert.pem", content = tls_locally_signed_cert.nomad_client.cert_pem },
        { path = "/etc/certs.d/key.pem", content = tls_private_key.nomad_client.private_key_pem },
        {
          path    = "/etc/systemd/resolved.conf.d/docker.conf",
          content = <<-EOT
            [Resolve]
            DNSStubListener=yes
            DNSStubListenerExtra=172.17.0.1
          EOT
        },
        {
          path    = "/etc/docker/daemon.json",
          content = <<-EOT
            {
              "dns": ["172.17.0.1"],
              "registry-mirrors": [
                  "http://docker-hub-mirror.service.consul:5000"
              ]
            }
          EOT
        },
        {
          path = "/etc/consul.d/consul.hcl", content = templatefile(
            "cloud-init/consul-client.hcl", {
              consul_servers = values(local.consul_servers)
              encrypt_key    = random_id.consul_encrypt_key.b64_std
              agent_token    = data.consul_acl_token_secret_id.nomad_client_agent[each.key].secret_id
            }
          )
        },
        {
          path = "/etc/nomad.d/nomad.hcl", content = templatefile(
            "cloud-init/nomad-client.hcl", {
              node_pool    = local.nomad_node_pool[each.key]
              consul_token = data.consul_acl_token_secret_id.nomad_client[each.key].secret_id
            }
          )
        },
      ]
    })
  }
}

resource "lxd_instance" "nomad_client" {
  for_each = local.nomad_clients

  name     = each.key
  image    = "images:ubuntu/${var.ubuntu_version}/cloud"
  profiles = ["default", lxd_profile.nomad.name]

  limits = {
    cpu    = 1
    memory = "3GB"
  }

  config = {
    "cloud-init.user-data" = data.cloudinit_config.nomad_client[each.key].rendered
    "cloud-init.network-config" = yamlencode({
      version = 2
      ethernets = {
        eth0 = {
          addresses   = ["${each.value}/16"]
          routes      = [{ to = "default", via = local.gateway_address }]
          nameservers = { addresses = ["9.9.9.9", "149.112.112.112"] }
        }
      }
    })
    "security.nesting"    = true
    "security.privileged" = true
    "raw.lxc"             = local.nomad_client_raw_lxc
  }
}
