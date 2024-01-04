#!/bin/sh
set -e

mkdir /etc/systemd/resolved.conf.d/

cat <<EOF > /etc/systemd/resolved.conf.d/consul.conf
[Resolve]
DNS=127.0.0.1:8600
DNSSEC=false
Domains=~consul
EOF

chown root.root /etc/systemd/resolved.conf.d/consul.conf
chmod 644 /etc/systemd/resolved.conf.d/consul.conf
systemctl restart systemd-resolved