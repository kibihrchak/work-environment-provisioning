#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_GROUP=$(id -g ${SSH_USER})
TESTS=${ANSIBLE_PLAYBOOKS}
TESTS_DIR_DEFAULT="$(dirname "$0")/../files/tests"
TESTS_DIR="${ANSIBLE_TESTS_DIR:-${TESTS_DIR_DEFAULT}}"

echo "==> Running tests for all stated playbooks"
IFS=","
for test in $TESTS
do
    pytest --hosts="ansible://devvm" "${TESTS_DIR}/${test}.py"
done
