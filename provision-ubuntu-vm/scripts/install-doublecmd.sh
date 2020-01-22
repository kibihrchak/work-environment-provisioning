#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_GROUP=$(id -g ${SSH_USER})

echo "==> Installing Doublecmd"
sudo DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    doublecmd-gtk

echo "==> Copying configuration"
cp -a /tmp/files/config/doublecmd/. ~
