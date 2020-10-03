#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_GROUP=$(id -g ${SSH_USER})
PLAYBOOKS=${ANSIBLE_PLAYBOOKS}
PLAYBOOKS_DIR_DEFAULT="$(dirname "$0")/../files/playbooks"
PLAYBOOKS_DIR="${ANSIBLE_PLAYBOOKS_DIR:-${PLAYBOOKS_DIR_DEFAULT}}"

echo "==> Running Ansible for all stated playbooks"
IFS=","
for playbook in $PLAYBOOKS
do
    ansible-playbook "${PLAYBOOKS_DIR}/${playbook}.yml"
done
