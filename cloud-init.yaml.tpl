#cloud-config
ssh_authorized_keys:
  - ${ssh_key}

packages:
  - openssh-server