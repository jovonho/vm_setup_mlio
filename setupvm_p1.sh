#!/bin/bash

# Update packages
apt update -y
apt upgrade -y
apt autoremove -y

# Install bpftrace and dependencies
# Install mpstat
# Install pip3
# Install docker (don't install the snap version, it's a different package)
# Install NVIDIA drivers for Tesla V100 (1767MB!)
apt-get install -y bpftrace sysstat python3-pip docker.io nvidia-driver-510 nvidia-dkms-510

echo "#####################################################"
echo "Please manually reboot the instance from AWS Console"
echo "#####################################################"
exit 0