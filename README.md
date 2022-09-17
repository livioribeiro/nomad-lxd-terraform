# Hashicorp Nomad cluster with Terraform, LXD and Ansible

Terraform configuration to create a [Nomad](https://www.nomadproject.io) cluster
in [LXD](https://linuxcontainers.org/#LXD) using [Terraform](https://www.terraform.io)
and [Ansible](https://www.ansible.com/)

After deploying, the following urls will be available:

- http://traefik.localhost
- http://nomad.localhost
- http://consul.localhost

The cluster contains the following nodes:

- 3 Consul nodes
- 3 Nomad server nodes
- 5 Nomad client nodes (3 "apps" nodes, 2 "infra" node)
- 1 NFS server node
- 1 Load Balancer node running HAProxy

Terraform creates the machines and generates an inventory that Ansible uses to
provision the cluster.

Consul is used to bootstrap the Nomad cluster, for service discovery and service mesh.

The client infra nodes are the entrypoint of the cluster in which Traefik will be deployed
and use Consul service catalog to expose applications.

HAProxy is configured to load balance between the two infra nodes. The container will map
port 80 on the host in order to expose the services under `*.localhost`.

The proxy configuration exposes the services at `{{ service name }}.apps.localhost`,
so when you deploy the service [hello.nomad](hello.nomad),
it will be exposed at `hello-world.apps.localhost`

## NFS and CSI Plugin

For storage with the NFS node, a CSI plugin will be configured using the [RocketDuck CSI plugin](https://gitlab.com/rocketduck/csi-plugin-nfs).


The are also examples of [other CSI plugins](csi_plugins).

## Examples

There are 3 example jobs:

- [hello.nomad](examples/hello.nomad), a simples hello world
- [countdash.nomad](examples/countdash.nomad), shows the usage of consul connect
- [nfs](examples/nfs/), show how to setup volumes using the nfs csi plugin
