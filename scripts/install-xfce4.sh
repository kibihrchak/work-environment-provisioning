#!/bin/bash -eux

echo "==> Update package info"
apt update

echo "==> Installing XFCE4 prerequisites"
sudo apt install -y xorg xinit dbus-x11 upower --no-install-recommends

echo "==> Installing XFCE4 and additional stuff"
sudo apt install -y xfce4 xfce4-taskmanager xfce4-systemload-plugin xfce4-whiskermenu-plugin --no-install-recommends

#   [TODO] Some GTK theme?
#   [TODO] Copy theme, config files
#   [TODO] Configure bashrc so that xfce4 is started on login
