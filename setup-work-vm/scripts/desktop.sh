#!/bin/bash

SSH_USER=${SSH_USERNAME:-vagrant}

echo "==> Checking version of Ubuntu"
. /etc/lsb-release

echo "==> Installing ubuntu-desktop"
#   [TODO]
#apt-get install -y ubuntu-desktop

#   [TODO] Install xdm, XFCE
#   [TODO] Configure these things
