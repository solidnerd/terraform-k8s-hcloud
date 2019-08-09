#!/usr/bin/bash
set -eu

PRIVATE_IP=""
while [ -z $PRIVATE_IP ]
do
  sleep 1
  PRIVATE_IP=$(ifconfig | grep -A 1 'ens10' | tail -1 | awk '{print $2}'| cut -d ':' -f 2)
done
PUBLIC_IP=$(ifconfig | grep -A 1 'eth0' | tail -1 | awk '{print $2}'| cut -d ':' -f 2)
# Initialize Cluster

if [[ -n "$FEATURE_GATES" ]]
then
  kubeadm init --apiserver-advertise-address $PRIVATE_IP --pod-network-cidr=192.168.0.0/16 --apiserver-cert-extra-sans $PUBLIC_IP --feature-gates $FEATURE_GATES
else
  kubeadm init --apiserver-advertise-address $PRIVATE_IP --pod-network-cidr=192.168.0.0/16 --apiserver-cert-extra-sans $PUBLIC_IP
fi

systemctl enable docker kubelet

# used to join nodes to the cluster
kubeadm token create --print-join-command > /tmp/kubeadm_join

mkdir -p "$HOME/.kube"
cp /etc/kubernetes/admin.conf "$HOME/.kube/config"
