#!/bin/bash -eux

echo "==> Installing pip (needed for Ansible)"
DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    python3-pip

echo "==> Installing Ansible and Testinfra"
pip3 install \
    ansible \
    testinfra[ansible]

echo "==> Set up localhost in inventory"
mkdir -p /etc/ansible
cat >> /etc/ansible/hosts <<EOL
[devvm]
localhost ansible_connection=local
EOL
