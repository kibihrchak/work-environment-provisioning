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

echo "==> Installing udev rules needed for HW access"
curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/master/scripts/99-platformio-udev.rules | sudo tee /etc/udev/rules.d/99-platformio-udev.rules
sudo service udev restart

echo "==> Add users to groups needed for HW access"
sudo usermod -a -G dialout $SSH_USER
sudo usermod -a -G plugdev $SSH_USER
