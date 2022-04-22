
# Run as root

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

#Reboot VM (from AWS console)




# clone all mlcommons (maybe done in a previous step)
# Cp the workload we care about (image_segmentation)
git clone https://github.com/jovonho/training.git /mlcommons_training

# Had a problem with runtime=nvidia, went back and tried to install cuda docker (didnt have to do this before but there was a recent update that might have changed that)
/mlcommons_training/install_cuda_docker.sh 

mkdir -p /workloads
cp -r /mlcommons_training/image_segmentation/pytorch /workloads
mv /workloads/pytorch /workloads/imseg



# Install tracing tools
git clone https://github.com/jovonho/mlperf-traces.git /tracing_tools

#Mods done: disk name is xvda vs sda



#Clone Imseg raw data
mkdir /data
cd /data
git clone https://github.com/neheller/kits19
cd kits19
pip3 install -r requirements.txt
python3 -m starter_code.get_imaging
# Connection dropped after 100 cases the first time
# All good, downloading picks up where it left off!

mkdir preprocessed_data
mv data raw_data


# Build docker image
cd /workloads/imseg
docker build -t unet3d .

# Try to run
docker run --ipc=host -it --rm --runtime=nvidia -v /data/kits19/raw_data/:/raw_data -v /data/kits19/preprocessed_data/:/data -v /workloads/imseg/results:/results unet3d:latest /bin/bash

# It works now!


# I think renaming the raw_data for some reason changed the .nii.gz filename??? instead of segmentation.nii.gz it was imaging.nii.gz and git showed all the segmentation files as deleted.

# Shutdown GNOME desktop manager on startup




