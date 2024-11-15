# Containers 101

The create.sh script is designed to set up an isolated environment using Alpine Linux. Here is a breakdown of its functionality:

1. Create Filesystem: Downloads and extracts the Alpine Linux miniroot filesystem into /mnt/mycontainer. Creates a /proc directory inside the container's filesystem.
2. Set Up cgroups: Creates a cgroup named mycontainer for memory and CPU.
3. Set Up Network Namespace:
   * Creates a network namespace called mycontainer_ns.
   * Creates a virtual Ethernet (veth) pair, veth0 and veth1.
   * Assigns veth1 to the mycontainer_ns namespace.
   * Configures IP addresses for veth0 and veth1.
4. Run unshare within the network namespace to create a new mount namespace, a new PID namespace, and mounts the proc filesystem, then chroots into the container's filesystem and starts a shell.

![Demo](demo.gif)

This script essentially sets up a basic containerized environment with network isolation and a separate process namespace.

## Prerequisites

1. Linux machine
2. `libcgroup-dev` and `debootstrap`

Install the following

```sh
sudo apt update && sudo apt upgrade -y
sudo apt install -y libcgroup-dev debootstrap
```

## Quickstart

To create the container
```sh
sudo ./create.sh
```

To delete the container
```sh
sudo ./delete.sh
```
