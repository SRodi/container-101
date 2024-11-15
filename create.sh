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

# Set up cgroups v2
CGROUP_DIR=/sys/fs/cgroup/$C_NAME
mkdir -p $CGROUP_DIR
echo "+memory +cpu" > $CGROUP_DIR/cgroup.subtree_control
# Set memory limit to 1KB
echo 1024 > $CGROUP_DIR/memory.max
# Set CPU limit to 10ms per 100ms (10% of a CPU)
echo 10000 > $CGROUP_DIR/cpu.max

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
