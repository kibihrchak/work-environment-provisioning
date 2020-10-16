#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_GROUP=$(id -g ${SSH_USER})
SPECS=${ANSIBLE_PLAYBOOKS}
SPECS_DIR_DEFAULT="$(dirname "$0")/../files/spec"
SPECS_DIR="${ANSIBLE_SPEC_DIR:-${SPECS_DIR_DEFAULT}}"

echo "==> Running specs for all stated playbooks"
IFS=","
for spec in $SPECS
do
    pytest --hosts="ansible://devvm" "${SPECS_DIR}/${spec}.py"
done
