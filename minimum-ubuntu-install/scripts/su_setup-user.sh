#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vmuser}
SSH_PASS=${SSH_PASSWORD:-vmuser}
SSH_USER_HOME=${SSH_USER_HOME:-/home/${SSH_USER}}

echo "==> Create user (if not already present)"
if ! id -u $SSH_USER >/dev/null 2>&1; then
    echo "==> Creating $SSH_USER user"
    /usr/sbin/groupadd $SSH_USER
    /usr/sbin/useradd \
        $SSH_USER -g $SSH_USER -G sudo -d $SSH_USER_HOME --create-home
    echo "${SSH_USER}:${SSH_PASS}" | chpasswd
fi

echo "==> Giving ${SSH_USER} sudo powers"
echo "${SSH_USER}        ALL=(ALL)       NOPASSWD: ALL" >> \
    /etc/sudoers.d/$SSH_USER
chmod 440 /etc/sudoers.d/$SSH_USER
