# Presentation

These scripts are used to setup AWS p3 isntances with NVIDIA V100 GPUs with the data and code to run the MLCommons image segmentation workload, and my BPF traces to analyze their execution and I/O patterns.

# Instructions

Run `setupvm_p1.sh` first, then reboot the machine. This script will download docker, NVIDIA drivers

Then run `setupvm_p2.sh` to download the raw dataset, build the docker image and preprocess the data. 

Once the second script terminates, you are ready to launch the workload.