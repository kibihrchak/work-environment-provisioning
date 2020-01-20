#!/bin/bash -eux

cd ~/buildroot

sudo mount -t auto -o ro build/images/rootfs.ext4 /mnt/rpi/rfs
sudo mount -t auto -o ro build/images/boot.vfat /mnt/rpi/boot

sudo rsync -xa --delete /mnt/rpi/boot/ /tftp/rpi
sudo rsync -xa --delete /mnt/rpi/rfs/ /nfs/rpi

sudo umount /mnt/rpi/rfs
sudo umount /mnt/rpi/boot

sudo cp overlay/*.txt /tftp/rpi

sync
