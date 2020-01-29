#!/bin/bash -eux

#   [TODO]
cd ~/buildroot

sudo rm -rf /nfs/bbb/*
sudo rm -rf /tftp/bbb/*

sudo tar -xf build/images/rootfs.tar -C /nfs/bbb

sudo mkdir -p /tftp/bbb/dtbs
sudo cp build/images/zImage /tftp/bbb
sudo cp build/build/linux-5.3.14/arch/arm/boot/dts/am335x-boneblack.dtb /tftp/bbb/dtbs

sync
