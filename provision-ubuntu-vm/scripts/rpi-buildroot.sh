#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_GROUP=$(id -g ${SSH_USER})
BUILDROOT_BASE_NAME="buildroot-${BUILDROOT_VERSION}"
BUILDROOT_ARCHIVE_NAME="${BUILDROOT_BASE_NAME}.tar.gz"

echo "==> Installing file servers (NFS, TFTP)"
sudo apt install -y dnsmasq nfs-kernel-server --no-install-recommends

echo "==> Installing Buildroot-needed packages"
sudo apt install -y \
    sed make binutils gcc g++ bash patch libncurses-dev \
    gzip bzip2 perl tar cpio unzip rsync wget bc \
    --no-install-recommends

echo "==> Installing serial console, configuring user"
sudo apt install -y picocom --no-install-recommends
sudo usermod -a -G dialout ${SSH_USER}

echo "==> Configuring system"
sudo cp -R /tmp/files/config/rpi-buildroot/root/. /
sudo mkdir -p /nfs/rpi /tftp/rpi
sudo mkdir -p /mnt/rpi/boot /mnt/rpi/rfs

echo "==> Configuring Buildroot directory"
mkdir -p ~/buildroot/build
cp -R /tmp/files/config/rpi-buildroot/buildroot/. \
    ~/buildroot/
chmod 755 ~/buildroot/*.sh

echo "==> Getting Buildroot"
if [ -z "${BUILDROOT_ARCHIVE_PATH}" ]
then
    cd /tmp
    wget -c \
        "http://buildroot.org/downloads/${BUILDROOT_ARCHIVE_NAME}" \
        "http://buildroot.org/downloads/${BUILDROOT_ARCHIVE_NAME}.sign"
    grep MD5 "${BUILDROOT_ARCHIVE_NAME}.sign" | cut -d' ' -f2- | md5sum -c
    tar -ax \
        --owner "${SSH_USER}" \
        -f "${BUILDROOT_ARCHIVE_NAME}" \
        -C ~/buildroot/
    rm "${BUILDROOT_ARCHIVE_NAME}"

    echo "==> Configuring Buildroot repo"
    export BR2_DEFCONFIG=~/buildroot/defconfig
    cd ~/buildroot/build
    make -C ../${BUILDROOT_BASE_NAME} O="$(pwd)" defconfig

    echo "==> Executing build"
    ~/buildroot/build.sh
else
    tar -xzf "${BUILDROOT_ARCHIVE_PATH}" -C ~/buildroot \
        --checkpoint 1000
fi

echo "==> Deploying build to file servers"
~/buildroot/deploy.sh
