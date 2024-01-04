#!/bin/sh
set -e

export DEBIAN_FRONTEND=noninteractive

apt-get -q -y install nomad

sed -i '/\\[Service\\]/a User=nomad' /usr/lib/systemd/system/nomad.service
systemctl daemon-reload

systemctl enable nomad