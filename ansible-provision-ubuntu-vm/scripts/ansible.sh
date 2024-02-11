#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vmuser}
SSH_GROUP=$(id -g ${SSH_USER})
PLAYBOOKS=${ANSIBLE_PLAYBOOKS}
PLAYBOOKS_DIR_DEFAULT="$(dirname "$0")/../files/playbooks"
PLAYBOOKS_DIR="${ANSIBLE_PLAYBOOKS_DIR:-${PLAYBOOKS_DIR_DEFAULT}}"
PLAYBOOKS_ENVVARS="${ANSIBLE_ENVVARS:-}"

echo "==> Additional environment variables"
IFS=","
for envvar in $PLAYBOOKS_ENVVARS
do
    echo "==> - ${envvar}"
    export "${envvar}"
done

echo "==> Running Ansible for all stated playbooks"
IFS=","
for playbook in $PLAYBOOKS
do
    ansible-playbook "${PLAYBOOKS_DIR}/${playbook}.yml"
done
