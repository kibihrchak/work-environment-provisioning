#!/bin/bash -eux

function dd_report()
{
    dd if="$1" of="$2" bs="$3" &

    DDPID=$!

    while sudo kill -USR1 $DDPID
    do
        sleep 5
    done
}

DISK_USAGE_BEFORE_MINIMIZE=$(df -h)

echo "==> Clean up the apt cache"
apt-get -y autoremove --purge
apt-get -y autoclean
apt-get -y clean
rm -rf /var/lib/apt/lists/*

echo "==> Removing APT files"
find /var/lib/apt -type f | xargs rm -f

echo "==> Removing caches"
find /var/cache -type f -exec rm -rf {} \;

if grep ' /boot' /proc/mounts
then
    echo "==> Whiteout /boot"
    dd_report /dev/zero /boot/whitespace 1M
    rm /boot/whitespace
fi

echo '==> Clear out swap and disable until reboot'
set +e
swapuuid=$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)
case "$?" in
2 | 0) ;;
*) exit 1 ;;
esac
set -e
if [ "x${swapuuid}" != "x" ]; then
    # Whiteout the swap partition to reduce box size
    # Swap is disabled till reboot
    swappart=$(readlink -f /dev/disk/by-uuid/$swapuuid)
    /sbin/swapoff "${swappart}"
    dd_report /dev/zero "${swappart}" 1M
    /sbin/mkswap -U "${swapuuid}" "${swappart}"
fi

echo "==> Zero out the free space to save space in the final image"
dd_report /dev/zero /EMPTY 1M
rm -f /EMPTY

echo "==> Sync to avoid non-consistent data on Packer quit"
sync

echo "==> Disk usage before minimize"
echo "${DISK_USAGE_BEFORE_MINIMIZE}"

echo "==> Disk usage after minimize"
df -h
