#!/bin/sh
set -e

export DEBIAN_FRONTEND=noninteractive

apt-get -q update
apt-get -q -y install wget openssh-server

GPG_HASHICORP=https://apt.releases.hashicorp.com/gpg
GPG_HASHICORP_KEYRING=/usr/share/keyrings/hashicorp-archive-keyring.gpg

APT_HASHICORP="deb [arch=$(dpkg --print-architecture) signed-by=$GPG_HASHICORP_KEYRING] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

wget -q -O- $GPG_HASHICORP | gpg --dearmor -o $GPG_HASHICORP_KEYRING
echo $APT_HASHICORP > /etc/apt/sources.list.d/hashicorp.list

apt-get update