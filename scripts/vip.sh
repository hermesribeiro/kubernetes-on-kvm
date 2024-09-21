#! /bin/bash

docker run --network host --rm ghcr.io/kube-vip/kube-vip:v0.6.4 \
   	manifest pod \
    --interface lo \
	--address $2 \
    --controlplane \
	--services \
    --bgp \
	--localAS 65000 \
	--bgpRouterID $1 \
	--bgppeers $3:65000::false,$4:65000::false \
	| sudo tee /etc/kubernetes/manifests/kube-vip.yaml
