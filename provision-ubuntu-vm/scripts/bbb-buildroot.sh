#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_GROUP=$(id -g ${SSH_USER})
BUILDROOT_BASE_NAME="buildroot-${BUILDROOT_VERSION}"
BUILDROOT_ARCHIVE_NAME="${BUILDROOT_BASE_NAME}.tar.gz"

echo "==> Installing file servers (NFS, TFTP)"
sudo DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    tftpd-hpa nfs-kernel-server

echo "==> Installing Buildroot-needed packages"
sudo DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    sed make binutils gcc g++ bash patch libncurses-dev \
    gzip bzip2 perl tar cpio unzip rsync wget bc git

echo "==> Installing serial console, configuring user"
sudo DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    picocom
sudo usermod -a -G dialout ${SSH_USER}

echo "==> Configuring system"
sudo cp -R /tmp/files/config/bbb-buildroot/root/. /
sudo mkdir -p /nfs/bbb /tftp/bbb
sudo mkdir -p /mnt/bbb/boot /mnt/bbb/rfs

echo "==> Configuring Buildroot directory"
mkdir -p ~/buildroot/build
cp -R /tmp/files/config/bbb-buildroot/buildroot/. \
    ~/buildroot/
chmod 755 ~/buildroot/*.sh

echo "==> Getting Buildroot"
if [ -z "${BUILDROOT_ARCHIVE_PATH}" ]
then
    cd /tmp
    wget -c \
        --progress=dot:mega \
        "http://buildroot.org/downloads/${BUILDROOT_ARCHIVE_NAME}" \
        "http://buildroot.org/downloads/${BUILDROOT_ARCHIVE_NAME}.sign"
    grep MD5 "${BUILDROOT_ARCHIVE_NAME}.sign" | cut -d' ' -f2- | md5sum -c
    tar -ax \
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
