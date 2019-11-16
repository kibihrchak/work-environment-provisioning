#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
DISK_USAGE_BEFORE_CLEANUP=$(df -h)

# Make sure udev does not block our network - http://6.ptmc.org/?p=164
echo "==> Cleaning up udev rules"
rm -rf /dev/.udev/
rm /lib/udev/rules.d/75-persistent-net-generator.rules

echo "==> Cleaning up leftover dhcp leases"
if [ -d "/var/lib/dhcp" ]; then
    rm /var/lib/dhcp/*
fi

# Add delay to prevent "vagrant reload" from failing
echo "pre-up sleep 2" >>/etc/network/interfaces

echo "==> Cleaning up tmp"
rm -rf /tmp/*

echo "==> Cleanup apt cache"
apt-get -y autoremove --purge
apt-get -y autoclean
apt-get -y clean
rm -rf /var/lib/apt/lists/*

echo "==> Remove Bash history"
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/${SSH_USER}/.bash_history

echo "==> Clean up log files"
find /var/log/ -name *.log -exec rm -f {} \;
find /var/log -type f | while read f; do echo -ne '' >"${f}"; done

echo "==> Clearing last login information"
>/var/log/lastlog
>/var/log/wtmp
>/var/log/btmp

# Make sure we wait until all the data is written to disk, otherwise
# Packer might quite too early before the large files are deleted
sync
