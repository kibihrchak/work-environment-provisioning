#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_GROUP=$(id -g ${SSH_USER})

echo "==> Installing needed development tools"
sudo DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    cmake clang-tidy clang-format
