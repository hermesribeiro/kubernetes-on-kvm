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

# Install local-pv
# Obviously optimizable
git clone https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner.git
cd sig-storage-local-static-provisioner
kubectl create -f deployment/kubernetes/example/default_example_storageclass.yaml
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm template ./helm/provisioner > deployment/kubernetes/provisioner_generated.yaml
kubectl create -f deployment/kubernetes/provisioner_generated.yaml