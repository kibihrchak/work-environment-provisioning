#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
DISK_USAGE_BEFORE_CLEANUP=$(df -h)

#   [TODO] This may go to export
# Make sure udev does not block our network - http://6.ptmc.org/?p=164
echo "==> Cleaning up udev rules"
rm -rf /dev/.udev/
rm -f /lib/udev/rules.d/75-persistent-net-generator.rules

#   [TODO] This may go to export
echo "==> Cleaning up leftover dhcp leases"
rm -rf /var/lib/dhcp/*

#   [TODO] This may go to export
echo "==> Add delay to prevent \"vagrant reload\" from failing"
if [ -f /etc/network/interfaces ]
then
echo "pre-up sleep 2" >>/etc/network/interfaces
fi

echo "==> Cleaning up tmp"
rm -rf /tmp/*

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

echo "==> [TODO] Clean Python pip cache"

echo "==> Sync to avoid non-consistent data on Packer quit"
sync
