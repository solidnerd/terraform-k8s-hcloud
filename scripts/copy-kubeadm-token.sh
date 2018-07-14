#!/bin/bash
set -eu
SSH_PRIVATE_KEY=${SSH_PRIVATE_KEY:-}
SSH_USERNAME=${SSH_USERNAME:-}
SSH_HOST=${SSH_HOST:-}

TARGET=${TARGET:-}

mkdir -p "${TARGET}"

scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    -i "${SSH_PRIVATE_KEY}" \
    "${SSH_USERNAME}@${SSH_HOST}:/tmp/kubeadm_join" \
    "${TARGET}"

scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    -i "${SSH_PRIVATE_KEY}" \
    "${SSH_USERNAME}@${SSH_HOST}:/etc/kubernetes/admin.conf" \
    "${TARGET}"
