#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_GROUP=$(id -g ${SSH_USER})

echo "==> Installing PlatformIO prerequisites"
sudo DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    python3 python3-distutils

echo "==> Installing PlatformIO"
python3 -c \
    "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/develop/scripts/get-platformio.py)"
