#!/bin/bash

set -e

sudo kubeadm init --control-plane-endpoint $1 --upload-certs

mkdir -p ~/.kube
sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config

kubectl apply -f "https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml"

sleep 2

kubectl get nodes
kubectl get pods -A

