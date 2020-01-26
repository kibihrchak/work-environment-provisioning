#!/bin/bash -eux

sed -i 's/^\(GRUB_CMDLINE_LINUX_DEFAULT=\)".*"/\1""/' /etc/default/grub
update-grub
