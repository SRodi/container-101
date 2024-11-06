# Containers 101

## Create a VM (optional)

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