# Kubernetes on kvm

This repo showcases the creation of an on-premisses kubernetes cluster that can run on regular PCs. It tries to use as much as much as possible cloud-native and linux native tools. The requirements were:

* Use the default kubernetes implementation for learning purposes.
* Nodes must run inside virtual machines for easy setup/teardown.
* The VMs should not need any proprieary license because FOSS>>all.
* It should be possible to SSH into any node from any node and from any local machine.
* High Availability so the user can mess up a node without destroiying the entire cluster.

To achieve those goals, the technologies involved were:

* kubeadm to install kubernetes components.
* qemu/kvm to create the virtual machines.
* Ubuntu 22.04 as the guest node image.
* A bridge network
* kube-vip to create a virtual IP load balancers
* Weave-net for kubernetes network policy

## Prerequisites

* Linux host OS
* [Task](https://taskfile.dev/installation/).
* A network bridge. [Here](https://www.tecmint.com/create-network-bridge-in-ubuntu/) is a good tutorial and [here](https://www.core27.co/post/bridge-networks-for-kvm-on-ubuntu-2204-server) is a good explanation.

## Quickstart

The proposed architecture consists of three nodes that acts as control-plane and worker nodes at the same time. The three nodes can run in the same host or in different hosts. The common steps for both approaches are as follows.

Install the required packages and reboot the host:

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


### Same host deployment

| host1             |
|-------------------|
| node1 node2 node3 |

```bash
task e2e
```

### Separate hosts deployment

| host1 | host2 | host3 |
|-------|-------|-------|
| node1 | node2 | node3 |

On each host machine run

```bash
# host1
task e2e-node-1

# host2
task e2e-node-2

# host3
task e2e-node-3
```

### Teardown

To delete all VMs run:

```bash
task delete-all
```

## Usefull virsh commands

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
