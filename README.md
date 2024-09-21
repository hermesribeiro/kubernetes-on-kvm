# Kubernetes on kvm

This repo showcases a kubernetes cluster I run on my homelab. It tries to use as much as much as possible cloud-native and linux native tools. The requirements were:

* Use default kubernetes implementation
* Nodes must run inside virtual machines for easy setup/teardown.
* The VMs should not need any proprieary license.
* It should be possible to SSH into any node from any node and from any local machine.
* Any machine can be turned off at any point and the cluster should still keep running.

To achieve those goals, the technologies involved were:

* kubeadm to install kubernetes components
* qemu/kvm to create the virtual machines
* Ubuntu 22.04 as the node image
* kube-vip to create a virtual IP load balancers
* A bridge network
* Weave-net for network policy

## Prerequisites

* Linux host OS
* [Task](https://taskfile.dev/installation/).
* A network bridge. [Here](https://www.tecmint.com/create-network-bridge-in-ubuntu/) is a good tutorial and [here](https://www.core27.co/post/bridge-networks-for-kvm-on-ubuntu-2204-server) is a good explanation.

## Quickstart

The initial cluster architecture will run in two machines, with two nodes/VMs in each one using high availability setup. Due to the way kube-vip is used, any other node configuration requires manually editing the node IPs.

| host1       | host2       |
|-------------|-------------|
| node1 node2 | node3 node4 |


To run it, install the required packages and reboot the machine:

```bash
task install
```

Download base ubuntu .img file:

```bash
task download-image
```

Create a password for direct vm console access:

```bash
echo <your password here> | mkpasswd -m sha-512 -s
```

Create a secrets file with the password hash aand an ssh import ID:

```bash
cat <<EOF | tee secrets.env
SSH_IMPORT_ID="Your ID here"
PASSWD_HASH="Your hash here"
```

Edit the IP adresses in the header of `Taskfile.yaml` to match your bridge network specs.

Use the following in your ~/.ssh/config and edit the host accordingly.

```
Host 192.168.0.8*
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  User sobeck
  LogLevel QUIET
```
Create the first host with two VMs and install kubernetes et.al.:

```bash
task host1
```

Create the second host on a second computer with two VMs and bootstrap them to the cluster.

```bash
task host2
```

Merge or create the cluster's kubeconfig.

```bash
task kubeconfig
```

WARNING: If the task above goes wrong, restore the ~/.kube/config-backup

## virsh commands

```bash
virsh list
virsh list --all
virsh start cloud-init-001
virsh console cloud-init-001
virsh shutdown cloud-init-001
```

## TODO

- Setup external ingress.
- Change network policy provider
