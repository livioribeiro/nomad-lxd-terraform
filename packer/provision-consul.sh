#!/bin/sh
set -e

export DEBIAN_FRONTEND=noninteractive

apt-get -q update
apt-get -q -y install consul

systemctl enable consul
