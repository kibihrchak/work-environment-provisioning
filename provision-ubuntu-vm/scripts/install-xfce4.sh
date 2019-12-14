#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_USER_HOME=${SSH_USER_HOME:-/home/${SSH_USER}}

echo "==> Update package info"
apt update

echo "==> Installing XFCE4 prerequisites"
apt install -y xorg xinit dbus-x11 upower --no-install-recommends

echo "==> Installing XFCE4 and additional stuff"
apt install -y xfce4 xfce4-taskmanager xfce4-systemload-plugin xfce4-whiskermenu-plugin --no-install-recommends

echo "==> Installing Doublecmd"
apt install doublecmd-gtk --no-install-recommends

echo "==> Installing themes, icons"
apt install -y elementary-xfce-icon-theme greybird-gtk-theme --no-install-recommends

echo "==> Removing unused stuff"
apt remove --purge humanity-icon-theme

echo "==> Unpacking configuration"
tar -xzf /tmp/config.tgz -C ~
chown -R $SSH_USER:$SSH_USER $SSH_USER_HOME/.config
