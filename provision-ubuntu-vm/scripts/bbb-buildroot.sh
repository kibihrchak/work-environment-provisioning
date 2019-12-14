#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_GROUP=$(id -g ${SSH_USER})

echo "==> Installing network configuration (netplan)"
#   [TODO]

echo "==> Installing file servers (NFS, TFTP)"
apt install tftpd nfs-kernel-server --no-install-recommends

echo "==> Installing Buildroot"
#   [TODO]

echo "==> Copying configuration"
#   [TODO]

echo "==> Executing build"
#   [TODO]

echo "==> Deploying build to file servers"
#   [TODO]
