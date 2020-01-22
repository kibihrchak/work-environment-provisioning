#!/bin/bash -eux

echo "==> Updating list of repositories"
apt -y update

if [[ $UPGRADE  =~ true || $UPGRADE =~ 1 || $UPGRADE =~ yes ]]; then
    echo "==> Performing dist-upgrade (all packages and kernel)"
    apt -y dist-upgrade --force-yes
    reboot
    sleep 60
fi
