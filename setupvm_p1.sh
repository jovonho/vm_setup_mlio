#!/bin/bash

# Force running as root
if [ "${EUID:-$(id -u)}" -ne 0 ]
then
        echo "Run script as root"
        exit -1
fi

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
echo "Please manually edit /etc/default/grub, changing" \
echo "\tGRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\""
echo "to"
echo "\tGRUB_CMDLINE_LINUX_DEFAULT=\"text\""
echo "then run update-grub"
echo "Finally, manually reboot the instance from AWS Console"
echo "#####################################################"
exit 0


https://askubuntu.com/questions/16371/how-do-i-disable-x-at-boot-time-so-that-the-system-boots-in-text-mode 