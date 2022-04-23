#!/bin/bash

sudo su -

# clone all mlcommons (maybe done in a previous step)
# Cp the workload we care about (image_segmentation)
git clone https://jovonho:${GIT_API_TOKEN}@github.com/jovonho/training.git /mlcommons_training

# Had a problem with runtime=nvidia, went back and tried to install cuda docker (didnt have to do this before but there was a recent update that might have changed that)
/mlcommons_training/install_cuda_docker.sh 

mkdir -p /workloads
cp -r /mlcommons_training/image_segmentation/pytorch /workloads
mv /workloads/pytorch /workloads/imseg


# Install tracing tools
git clone https://jovonho:${GIT_API_TOKEN}@github.com/jovonho/mlperf-traces.git /tracing_tools

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

# Run container (in non-iteractive mode) to preprocess data
docker run -it --ipc=host --runtime=nvidia -v /data/kits19/raw_data/:/raw_data -v /data/kits19/preprocessed_data/:/data -v /workloads/imseg/results:/results unet3d:latest python3 preprocess_dataset.py --data_dir /raw_data --results_dir /data

echo "#####################################################"
echo "All done"
echo "#####################################################"
exit 0