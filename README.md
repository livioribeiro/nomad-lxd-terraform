# Hashicorp Nomad cluster with Consul, Traefik, Terraform and LXD

[Terraform](https://www.terraform.io) plan to create a [Nomad](https://www.nomadproject.io) cluster
with [Consul](https://www.consul.io), [Traefik](https://traefik.io/traefik/)
and [Prometheus](https://prometheus.io/) using [LXD](https://linuxcontainers.org/#LXD)

[Packer](https://www.packer.io/) is used to build the LXD images used to create the containers.

The cluster contains 11 nodes:

- 3 Consul nodes
- 3 Nomad server nodes
- 3 Nomad client nodes
- 1 Traefik node
- 1 Prometheus node

Consul is used to bootstrap the Nomad cluster, for service discovery
and for the service mesh

Traefik is the entrypoint of the cluster.
It will use Consul service catalog to expose the services.

The proxy configuration exposes the services at `{{ service name }}.service.127.0.0.1.nip.io`,
so when you deploy the service [hello.nomad](hello.nomad),
it will be exposed at `hello-world.service.127.0.0.1.nip.io`

There are 3 example jobs:

- [hello.nomad](hello.nomad), a simples hello world
- [countdash.nomad](countdash.nomad), shows the usage of consul connect
- [grafana.nomar](grafana.nomad), just deploys [Grafana](https://grafana.com)