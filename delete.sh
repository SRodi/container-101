#!/bin/bash
set -e

C_NAME=mycontainer

# Clean up cgroups
cgdelete -g memory,cpu:$C_NAME

# Clean up network namespaces
ip netns delete "${C_NAME}_ns"

# Clean up filesystem
rm -rf /mnt/$C_NAME