#!/bin/sh
set -ex

export DEBIAN_FRONTEND=noninteractive

GPG_HASHICORP_KEYRING=/usr/share/keyrings/hashicorp.gpg
SOURCE_HASHICORP="deb [arch=$(dpkg --print-architecture) signed-by=$GPG_HASHICORP_KEYRING] $APT_HASHICORP $(lsb_release -cs) main"

GPG_DOCKER_KEYRING=/usr/share/keyrings/docker.gpg
SOURCE_DOCKER="deb [arch=$(dpkg --print-architecture) signed-by=$GPG_DOCKER_KEYRING] $APT_DOCKER $(lsb_release -cs) stable"

GPG_GETENVOY_KEYRING=/usr/share/keyrings/getenvoy-keyring.gpg
SOURCE_GETENVOY="deb [arch=$(dpkg --print-architecture) signed-by=$GPG_GETENVOY_KEYRING] $APT_GETENVOY $(lsb_release -cs) main"

apt-get -q update
apt-get -q -y install wget unzip

wget -q -O- $GPG_HASHICORP | gpg --dearmor -o $GPG_HASHICORP_KEYRING
echo $SOURCE_HASHICORP > /etc/apt/sources.list.d/hashicorp.list

wget -q -O- $GPG_DOCKER | gpg --dearmor -o $GPG_DOCKER_KEYRING
echo $SOURCE_DOCKER > /etc/apt/sources.list.d/docker.list

wget -q -O- $GPG_GETENVOY | gpg --dearmor -o $GPG_GETENVOY_KEYRING
echo $SOURCE_GETENVOY > /etc/apt/sources.list.d/getenvoy.list

apt-get -q update
apt-get -q -y install consul nomad docker-ce containerd.io getenvoy-envoy nfs-common

mkdir -p /etc/systemd/resolved.conf.d
cat <<EOF > /etc/systemd/resolved.conf.d/consul.conf
[Resolve]
DNS=127.0.0.1:8600
DNSSEC=false
Domains=~consul
EOF

systemctl restart systemd-resolved

# cni plugins
mkdir -p /opt/cni/bin
wget -q -O /tmp/cni-plugins.tgz $CNI_PLUGINS_URL
tar -vxf /tmp/cni-plugins.tgz -C /opt/cni/bin

# consul cni plugin
wget -q -O /tmp/consul-cni.zip $CONSUL_CNI_URL
unzip /tmp/consul-cni.zip consul-cni -d /opt/cni/bin

chown -R root.root /opt/cni/bin
chmod 755 /opt/cni/bin/*
rm /tmp/cni-plugins.tgz

usermod -aG docker nomad

# install loki logging driver
docker plugin install grafana/loki-docker-driver:$LOKI_DRIVER_VERSION --alias loki --grant-all-permissions

# cleanup
apt-get -q -y purge wget unzip
apt-get -q -y clean
apt-get -q -y autoclean
