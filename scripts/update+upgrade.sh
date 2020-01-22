#!/bin/bash -eux

echo "==> Updating list of repositories"
sudo apt -y update

if [[ $UPGRADE  =~ true || $UPGRADE =~ 1 || $UPGRADE =~ yes ]]; then
    echo "==> Performing dist-upgrade (all packages and kernel)"
    sudo DEBIAN_FRONTEND=noninteractive apt -y dist-upgrade --force-yes
    sudo reboot
    sleep 60
fi
