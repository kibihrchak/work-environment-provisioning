#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_GROUP=$(id -g ${SSH_USER})

echo "==> Installing XFCE4 prerequisites"
apt install -y xorg xinit dbus-x11 upower --no-install-recommends

echo "==> Installing XFCE4 and additional stuff"
apt install -y xfce4 xfce4-taskmanager xfce4-systemload-plugin xfce4-whiskermenu-plugin --no-install-recommends

echo "==> Installing themes, icons"
apt install -y elementary-xfce-icon-theme greybird-gtk-theme --no-install-recommends

echo "==> Removing unused stuff"
apt remove --purge humanity-icon-theme

echo "==> Copying configuration"
cp -a /tmp/files/config/xfce4/. ~
