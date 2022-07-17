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
apt-get install -y bpftrace sysstat python3-pip docker.io


# clone all mlcommons (maybe done in a previous step)
# Cp the workload we care about (image_segmentation)
git clone https://jovonho:${GIT_API_TOKEN}@github.com/jovonho/training.git /mlcommons_training

pushd /mlcommons_training
git remote set-url origin https://jovonho:${GIT_API_TOKEN}@github.com/jovonho/training.git
popd

# Had a problem with runtime=nvidia, went back and tried to install cuda docker (didnt have to do this before but there was a recent update that might have changed that)
/mlcommons_training/install_cuda_docker.sh 

# Install tracing tools
git clone https://jovonho:${GIT_API_TOKEN}@github.com/jovonho/mlperf-traces.git /tracing_tools
pushd /tracing_tools
# Set the remote url with the token 
git remote set-url origin https://jovonho:${GIT_API_TOKEN}@github.com/jovonho/mlperf-traces.git
popd


# Install experiment scheduling tools
git clone https://jovonho:${GIT_API_TOKEN}@github.com/jovonho/experiments.git /experiments
pushd /experiments
git remote set-url origin https://jovonho:${GIT_API_TOKEN}@github.com/jovonho/experiments.git
popd


#Clone Imseg raw data
mkdir /data
cd /data
git clone https://github.com/neheller/kits19
cd kits19
pip3 install -r requirements.txt
python3 -m starter_code.get_imaging

# Often the connection drops with some cases remaining.
# Check if there are 300 and if not, restart the download
# if picks up where it left off automatically.
num_cases=$(ls | grep case_ | wc -w)
if [[ num_cases -lt 300 ]]
then
	python3 -m starter_code.get_imaging
fi

mkdir preprocessed_data


# Copy workload to shorter location
mkdir -p /workloads
cp -r /mlcommons_training/image_segmentation/pytorch /workloads
mv /workloads/pytorch /workloads/imseg

# Build docker image
cd /workloads/imseg
docker build -t unet3d .

# Run container (in non-iteractive mode) to preprocess data
docker run -it --ipc=host --runtime=nvidia -v /data/kits19/data/:/raw_data -v /data/kits19/preprocessed_data/:/data -v /workloads/imseg/results:/results unet3d:latest python3 preprocess_dataset.py --data_dir /raw_data --results_dir /data

echo "#####################################################"
echo "All done"
echo "#####################################################"
exit 0
