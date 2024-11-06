#!/bin/bash
set -e

# Clean up cgroups
sudo cgdelete -g memory,cpu:mycontainer

# Clean up network namespaces
sudo ip netns delete mycontainer_ns

# Clean up filesystem
sudo rm -rf /mnt/mycontainer