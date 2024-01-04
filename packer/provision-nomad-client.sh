#!/bin/sh
set -e

export DEBIAN_FRONTEND=noninteractive

GPG_DOCKER=https://download.docker.com/linux/ubuntu/gpg
GPG_GETENVOY=https://deb.dl.getenvoy.io/public/gpg.8115BA8E629CC074.key

GPG_DOCKER_KEYRING=/usr/share/keyrings/docker.gpg
APT_DOCKER="deb [arch=$(dpkg --print-architecture) signed-by=$GPG_DOCKER_KEYRING] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

GPG_GETENVOY_KEYRING=/usr/share/keyrings/getenvoy-keyring.gpg
APT_GETENVOY="deb [arch=$(dpkg --print-architecture) signed-by=$GPG_GETENVOY_KEYRING] https://deb.dl.getenvoy.io/public/deb/ubuntu $(lsb_release -cs) main"

CNI_PLUGINS_URL=https://github.com/containernetworking/plugins/releases/download/v$CNI_PLUGINS_VERSION/cni-plugins-linux-amd64-v$CNI_PLUGINS_VERSION.tgz

wget -q -O- $GPG_DOCKER | gpg --dearmor -o $GPG_DOCKER_KEYRING
echo $APT_DOCKER > /etc/apt/sources.list.d/docker.list

wget -q -O- $GPG_GETENVOY | gpg --dearmor -o $GPG_GETENVOY_KEYRING
echo $APT_GETENVOY > /etc/apt/sources.list.d/getenvoy.list

apt-get -q update
apt-get -q -y install nomad docker-ce containerd.io getenvoy-envoy nfs-common
systemctl enable nomad

mkdir -p /opt/nomad/data
chown -R nomad:nomad /opt/nomad

# cni plugins
mkdir -p /opt/cni/bin
wget -q -O /tmp/cni-plugins.tgz $CNI_PLUGINS_URL
tar -vxf /tmp/cni-plugins.tgz -C /opt/cni/bin
chown root.root /opt/cni/bin
chmod 755 /opt/cni/bin/*
rm /tmp/cni-plugins.tgz

usermod -aG docker nomad

apt-get -q -y clean
apt-get -q -y autoclean

# expose consul dns to docker
mkdir -p /etc/systemd/resolved.conf.d/

cat <<EOF > /etc/systemd/resolved.conf.d/docker.conf
[Resolve]
DNSStubListener=yes
DNSStubListenerExtra=172.17.0.1
EOF

chown root.root /etc/systemd/resolved.conf.d/docker.conf
chmod 644 /etc/systemd/resolved.conf.d/docker.conf
systemctl restart systemd-resolved

# configure docker daemon
cat <<EOF > /etc/docker/daemon.json
{
  "dns": ["172.17.0.1"],
  "registry-mirrors": [
    "http://docker-hub-mirror.service.consul:5000"
  ]
}
EOF

chown root.root /etc/docker/daemon.json
chmod 644 /etc/docker/daemon.json
systemctl enable docker
systemctl restart docker

# install loki logging driver
docker plugin install grafana/loki-docker-driver:$LOKI_DRIVER_VERSION --alias loki --grant-all-permissions

mount --make-shared /