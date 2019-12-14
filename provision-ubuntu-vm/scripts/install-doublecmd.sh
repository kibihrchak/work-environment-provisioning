#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_GROUP=$(id -g ${SSH_USER})

echo "==> Installing Doublecmd"
apt install doublecmd-gtk --no-install-recommends

echo "==> Copying configuration"
cp -a /tmp/files/config/doublecmd/. ~
