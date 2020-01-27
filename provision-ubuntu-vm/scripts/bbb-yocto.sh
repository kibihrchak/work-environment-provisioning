#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_GROUP=$(id -g ${SSH_USER})
YOCTO_DOWNLOAD_BASE="http://downloads.yoctoproject.org/releases/yocto/yocto-${YOCTO_VERSION}"
POKY_ARCHIVE_BASE_NAME="poky-${POKY_VERSION}.tar.bz2"

echo "==> Installing file servers (NFS, TFTP)"
sudo DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    tftpd-hpa nfs-kernel-server

echo "==> Installing Yocto-needed packages"
sudo DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    bc build-essential chrpath cpio diffstat \
    gawk git python texinfo wget

echo "==> Installing serial console, configuring user"
sudo DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    picocom
sudo usermod -a -G dialout ${SSH_USER}

echo "==> Configuring system"
sudo cp -R /tmp/files/config/bbb-yocto/root/. /
sudo mkdir -p /nfs/bbb /tftp/bbb
sudo mkdir -p /mnt/bbb/boot /mnt/bbb/rfs

#   [TODO]
echo "==> Configuring Yocto directory"
mkdir -p ~/yocto/build
cp -R /tmp/files/config/bbb-yocto/yocto/. \
    ~/yocto/
chmod 755 ~/yocto/*.sh

if [ -z "${YOCTO_ARCHIVE_PATH}" ]
then
    echo "==> Set up wget (assuming not configured before)"
    echo "dot_bytes=100k" > ~/.wgetrc

    echo "==> Getting Yocto from source"
    cd /tmp
    wget -c \
        "${YOCTO_DOWNLOAD_BASE}/${POKY_ARCHIVE_BASE_NAME}" \
        "${YOCTO_DOWNLOAD_BASE}/${POKY_ARCHIVE_BASE_NAME}.md5sum"
    md5sum -c ${POKY_ARCHIVE_BASE_NAME}.md5sum
    tar -ax \
        -f "${POKY_ARCHIVE_BASE_NAME}" \
        -C ~/yocto/
    rm "${POKY_ARCHIVE_BASE_NAME}" "${POKY_ARCHIVE_BASE_NAME}.md5sum"

    #   [TODO]
    echo "==> Configuring Yocto repo"
    export BR2_DEFCONFIG=~/buildroot/yocto
    cd ~/yocto/build
    make -C ../${BUILDROOT_BASE_NAME} O="$(pwd)" defconfig

    echo "==> Executing build"
    ~/yocto/build.sh

    echo "==> Restore wget config"
    rm ~/.wgetrc
else
    echo "==> Getting prebuilt Yocto archive"
    tar --checkpoint=10000 -xz \
        -f "${YOCTO_ARCHIVE_PATH}" -C ~/yocto
fi

echo "==> Deploying build to file servers"
~/yocto/deploy.sh
