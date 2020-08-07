#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_GROUP=$(id -g ${SSH_USER})
PLAYBOOKS=${ANSIBLE_PLAYBOOKS}

echo "==> Running Ansible for all stated playbooks"
IFS=","
for playbook in $PLAYBOOKS
do
    ansible-playbook "/tmp/files/playbooks/${playbook}.yml"
done
