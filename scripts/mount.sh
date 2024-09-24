#! /bin/bash

sudo mkdir -p /mnt/fast-disks/vdb
sudo mkfs.ext4 /dev/vdb
sudo mount /dev/vdb /mnt/fast-disks/vdb
echo "/dev/vdb   /mnt/fast-disks/vdb   ext4   defaults  0 0" | sudo tee -a /etc/fstab
