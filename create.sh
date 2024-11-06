#!/bin/bash
set -e

# Create a basic filesystem for Alpine Linux
sudo mkdir -p /mnt/mycontainer
sudo wget -P /mnt/mycontainer http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64/alpine-minirootfs-3.20.0-x86_64.tar.gz
sudo tar -xzf /mnt/mycontainer/alpine-minirootfs-3.20.0-x86_64.tar.gz -C /mnt/mycontainer

# Set up cgroups
sudo mkdir -p /sys/fs/cgroup/mycontainer
sudo cgcreate -a $(whoami) -g memory,cpu:mycontainer

# Set up network namespace
sudo ip netns add mycontainer_ns

# Create veth pairs
sudo ip link add veth0 type veth peer name veth1

# Assign veth1 to the container's network namespace
sudo ip link set veth1 netns mycontainer_ns

# Set up veth interfaces
sudo ip netns exec mycontainer_ns ip addr add 10.0.0.1/24 dev veth1
sudo ip netns exec mycontainer_ns ip link set veth1 up
sudo ip link set veth0 up
sudo ip addr add 10.0.0.2/24 dev veth0
sudo ip link set veth0 up

# Create proc directory and mount proc filesystem
sudo mkdir -p /mnt/mycontainer/proc

# Use unshare to create a new mount namespace and mount proc filesystem
sudo unshare --mount --pid --fork --net --uts --mount-proc=/mnt/mycontainer/proc chroot /mnt/mycontainer /bin/ash
