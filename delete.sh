#!/bin/bash
set -e

C_NAME=mycontainer

# Clean up cgroups
sudo cgdelete -g memory,cpu:$C_NAME

# Clean up network namespaces
sudo ip netns delete "${C_NAME}_ns"

# Clean up filesystem
sudo rm -rf /mnt/$C_NAME