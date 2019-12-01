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

#   [TODO] Should this be removed? What if user installed them on purpose?
echo "==> Removing all linux kernels except the currrent one"
dpkg --list | awk '{ print $2 }' | grep -e 'linux-\(headers\|image\)-.*[0-9]\($\|-generic\)' | grep -v "$(uname -r | sed 's/-generic//')" | xargs apt-get -y purge
echo "==> Removing linux source"
dpkg --list | awk '{ print $2 }' | grep linux-source | xargs apt-get -y purge
echo "==> Removing development packages"
dpkg --list | awk '{ print $2 }' | grep -- '-dev$' | xargs apt-get -y purge
echo "==> Removing documentation"
dpkg --list | awk '{ print $2 }' | grep -- '-doc$' | xargs apt-get -y purge
echo "==> Removing obsolete networking components"
apt-get -y purge ppp pppconfig pppoeconf

#   [TODO] This doesn't work
echo "==> Clean up orphaned packages with deborphan"
apt-get -y install deborphan
while [ -n "$(deborphan --guess-all --libdevel)" ]; do
  deborphan --guess-all --libdevel | xargs apt-get -y purge
done
apt-get -y purge deborphan dialog

echo "==> Clean up the apt cache"
apt-get -y autoremove --purge
apt-get -y autoclean
apt-get -y clean
rm -rf /var/lib/apt/lists/*

#   [TODO] Should this be removed? What if user installed them on purpose?
echo "==> Removing man pages"
rm -rf /usr/share/man/*
echo "==> Removing any docs"
rm -rf /usr/share/doc/*

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
