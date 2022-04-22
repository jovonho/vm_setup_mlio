#!/bin/bash

# Update packages
apt update -y
apt upgrade -y
apt autoremove -y

# Install bpftrace and dependencies
apt-get install -y bpftrace

# Install mpstat
apt install -y sysstat

# Install pip3
apt install -y python3-pip

# Install docker (don't install the snap version, it's a different package)
apt install -y docker.io

#Install NVIDIA drivers for Tesla V100 (1767MB!)
apt install -y nvidia-driver-510 nvidia-dkms-510

echo "#####################################################"
echo "Please manually reboot the instance from AWS Console"
echo "#####################################################"
exit 0