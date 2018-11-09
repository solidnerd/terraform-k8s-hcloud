#!/usr/bin/bash
set -eu

KUBERNETES_VERSION=${KUBERNETES_VERSION:-}
CORE_DNS=${CORE_DNS:-}

echo "
Package: kubectl
Pin: version ${KUBERNETES_VERSION}-*
Pin-Priority: 1000
" > /etc/apt/preferences.d/kubectl

apt-get install -qq -y kubectl

# Initialize Cluster
kubeadm init --feature-gates CoreDNS="$CORE_DNS"

systemctl enable docker kubelet

# used to join nodes to the cluster
kubeadm token create --print-join-command > /tmp/kubeadm_join

mkdir -p "$HOME/.kube"
cp /etc/kubernetes/admin.conf "$HOME/.kube/config"
