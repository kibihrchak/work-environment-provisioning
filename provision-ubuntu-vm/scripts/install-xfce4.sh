#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_GROUP=$(id -g ${SSH_USER})

echo "==> Installing XFCE4 prerequisites"
sudo DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    xorg xinit dbus-x11 upower

echo "==> Installing display manager"
sudo DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    policykit-1 lightdm lightdm-gtk-greeter

echo "==> Installing XFCE4 and additional stuff"
sudo DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    xfce4 xfce4-taskmanager \
    xfce4-systemload-plugin xfce4-whiskermenu-plugin

echo "==> Installing themes, icons"
sudo DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    elementary-xfce-icon-theme greybird-gtk-theme

echo "==> Removing unused stuff"
sudo DEBIAN_FRONTEND=noninteractive \
    apt remove -y --purge \
    humanity-icon-theme

echo "==> Copying configuration"
cp -a /tmp/files/config/xfce4/. ~
