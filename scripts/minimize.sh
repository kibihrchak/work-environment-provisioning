#!/bin/bash -eux

DISK_USAGE_BEFORE_MINIMIZE=$(df -h)

# Remove some packages to get a minimal install
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
echo "==> Removing LibreOffice"
apt-get -y purge libreoffice-core libreoffice-calc libreoffice-common libreoffice-draw libreoffice-gtk libreoffice-gnome libreoffice-impress libreoffice-math libreoffice-gtk libreoffice-ogltrans libreoffice-pdfimport libreoffice-writer
echo "==> Removing other oddities"
apt-get -y purge popularity-contest installation-report landscape-common aisleriot gnome-mines gnome-mahjongg gnome-sudoku rhythmbox rhythmbox-data libtotem-plparser-common transmission-common simple-scan thunderbird ubuntu-docs

# Clean up the apt cache
apt-get -y autoremove --purge
apt-get -y autoclean
apt-get -y clean

# Clean up orphaned packages with deborphan
apt-get -y install deborphan
while [ -n "$(deborphan --guess-all --libdevel)" ]; do
  deborphan --guess-all --libdevel | xargs apt-get -y purge
done
apt-get -y purge deborphan dialog

echo "==> Removing man pages"
rm -rf /usr/share/man/*
echo "==> Removing APT files"
find /var/lib/apt -type f | xargs rm -f
echo "==> Removing any docs"
rm -rf /usr/share/doc/*
echo "==> Removing caches"
find /var/cache -type f -exec rm -rf {} \;

#   [TODO] Add check whether the boot parition is the same one as the
#   root one, skip step in that case
#   [TODO] Add some progress information
echo "==> Whiteout /boot"
count=$(df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}')
let count--
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count
rm /boot/whitespace

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
    dd if=/dev/zero of="${swappart}" bs=1M || echo "dd exit code $? is suppressed"
    /sbin/mkswap -U "${swapuuid}" "${swappart}"
fi

#   [TODO] Add some progress information
echo "==> Zero out the free space to save space in the final image"
dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? is suppressed"
rm -f /EMPTY

# Make sure we wait until all the data is written to disk, otherwise
# Packer might quite too early before the large files are deleted
sync

echo "==> Disk usage before minimize"
echo "${DISK_USAGE_BEFORE_MINIMIZE}"

echo "==> Disk usage after minimize"
df -h
