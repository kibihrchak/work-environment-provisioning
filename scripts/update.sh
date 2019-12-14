#!/bin/bash -eux

echo "==> Updating list of repositories"
apt -y update

if [[ $UPDATE  =~ true || $UPDATE =~ 1 || $UPDATE =~ yes ]]; then
    echo "==> Performing dist-upgrade (all packages and kernel)"
    apt -y dist-upgrade --force-yes
    reboot
    sleep 60
fi
