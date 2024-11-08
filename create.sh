#!/bin/bash
set -e

C_NAME=mycontainer
FS_VERSION=alpine-minirootfs-3.20.0-x86_64.tar.gz
FS_DL_URL=http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64

# Create a basic filesystem for Alpine Linux
mkdir -p /mnt/$C_NAME
wget -P /mnt/$C_NAME $FS_DL_URL/$FS_VERSION
tar -xzf /mnt/$C_NAME/$FS_VERSION -C /mnt/$C_NAME
# Create proc directory and mount proc filesystem
mkdir -p /mnt/$C_NAME/proc

# Set up cgroups
mkdir -p /sys/fs/cgroup/$C_NAME
cgcreate -a $(whoami) -g memory,cpu:$C_NAME
# Set memory limit to 1KB
cgset -r memory.max=1024 $C_NAME
# Set CPU limit to 0.1 CPU core
cgset -r cpu.max=10000 $C_NAME

# Set up network namespace
ip netns add "${C_NAME}_ns"
# Create veth pairs
ip link add veth0 type veth peer name veth1
# Assign veth1 to the container's network namespace
ip link set veth1 netns "${C_NAME}_ns"
# Set up veth interfaces
ip netns exec "${C_NAME}_ns" ip addr add 10.0.0.1/24 dev veth1
ip netns exec "${C_NAME}_ns" ip link set veth1 up
ip link set veth0 up
ip addr add 10.0.0.2/24 dev veth0
ip link set veth0 up

# Run the unshare command within the network namespace.
ip netns exec "${C_NAME}_ns" \
    unshare --mount --pid --fork --uts --mount-proc=/mnt/$C_NAME/proc \
    chroot /mnt/$C_NAME /bin/ash
