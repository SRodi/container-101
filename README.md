# Containers 101

The create.sh script is designed to set up an isolated environment using Alpine Linux. Here is a breakdown of its functionality:

1. Create Filesystem: Downloads and extracts the Alpine Linux miniroot filesystem into /mnt/mycontainer.
2. Set Up cgroups: Creates a cgroup named mycontainer for memory and CPU.
3. Set Up Network Namespace:
   * Creates a network namespace called mycontainer_ns.
   * Creates a virtual Ethernet (veth) pair, veth0 and veth1.
   * Assigns veth1 to the mycontainer_ns namespace.
   * Configures IP addresses for veth0 and veth1.
   * Mount proc Filesystem:
4. Creates a /proc directory inside the container's filesystem.
5. Run unshare within the network namespace to create a new mount namespace, a new PID namespace, and mounts the proc filesystem, then chroots into the container's filesystem and starts a shell.

This script essentially sets up a basic containerized environment with network isolation and a separate process namespace.

## Create a VM (optional)

If you do not have a Linux VM you can use Vagrant.

Create file called `Vagrantfile`
```vagrant
Vagrant.configure("2") do |config|
    config.vm.box = "bento/ubuntu-24.04"
    config.vm.box_version = "202404.26.0"
    config.vm.synced_folder ".", "/vagrant_data"
end
```

Create VM
```sh
vagrant up
```

Sync scripts
```sh
vagrant ssh -c "sudo cp -r /vagrant_data/* /home/vagrant"
```

ssh into VM
```sh
vagrant ssh
```

## Prerequisites

Install the following

```sh
sudo apt update && sudo apt upgrade -y
sudo apt install -y cgroup-tools debootstrap
```

## Quickstart

To create the container
```sh
./create.sh
```

To delete the container
```sh
./delete.sh
```