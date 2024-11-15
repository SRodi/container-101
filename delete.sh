#!/bin/bash
set -e

C_NAME=mycontainer

# Clean up cgroups v2
CGROUP_DIR=/sys/fs/cgroup/$C_NAME
rmdir $CGROUP_DIR

# Clean up network namespaces
ip netns delete "${C_NAME}_ns"

# Clean up filesystem
rm -rf /mnt/$C_NAME