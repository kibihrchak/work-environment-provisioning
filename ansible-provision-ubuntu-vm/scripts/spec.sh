#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_GROUP=$(id -g ${SSH_USER})
SPECS=${ANSIBLE_PLAYBOOKS}

echo "==> Running specs for all stated playbooks"
IFS=","
for spec in $SPECS
do
    pytest --hosts="ansible://devvm" "/tmp/files/spec/${spec}.py"
done
