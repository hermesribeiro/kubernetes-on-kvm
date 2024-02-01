#! /bin/bash

kubeadm token create --print-join-command --certificate-key $(sudo kubeadm init phase upload-certs --upload-certs | tail -n 1)
