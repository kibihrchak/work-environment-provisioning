#!/bin/bash -eux

SSH_USER=${SSH_USERNAME:-vagrant}
SSH_GROUP=$(id -g ${SSH_USER})
TESTS=${ANSIBLE_PLAYBOOKS}
TESTS_DIR_DEFAULT="$(dirname "$0")/../files/tests"
TESTS_DIR="${ANSIBLE_TESTS_DIR:-${TESTS_DIR_DEFAULT}}"
TESTS_ENVVARS="${ANSIBLE_ENVVARS:-}"

echo "==> Additional environment variables"
IFS=","
for envvar in $TESTS_ENVVARS
do
    echo "==> - ${envvar}"
    export "${envvar}"
done

echo "==> Running tests for all stated playbooks"
IFS=","
for test in $TESTS
do
    pytest --hosts="ansible://devvm" "${TESTS_DIR}/${test}.py"
done
