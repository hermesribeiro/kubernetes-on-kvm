# Kubernetes on kvm

Multi-host self-managed kubadm kubernetes cluster on top of kvm/qemu virtual machines provisioned with libvirt CLI.

## Prerequisites

* Linux
* [Task](https://taskfile.dev/installation/).
* A network bridge. [Here](https://www.tecmint.com/create-network-bridge-in-ubuntu/) is a good tutorial and [here](https://www.core27.co/post/bridge-networks-for-kvm-on-ubuntu-2204-server) is a good explanation.

## Quickstart

The steps below are intended to be run in two different machines. It will create a cluster with five control-plane nodes intended to be used also as worker nodes with the config below.

| host1             | host2       |
|-------------------|-------------|
| node1 node2 node3 | node4 node5 |

Install the required packages and reboot the machine:

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

Use the following in yout ~/.ssh/config and edit the host accordingly.

```
Host 192.168.0.8*
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  User sobeck
  LogLevel QUIET
```
Create the first host with three VMs and install kubernetes et.al.:

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

- Test policy delete
- Setup external ingress.
- Force LB IP in kubeconfig
- Replace installs with ArgoCD
