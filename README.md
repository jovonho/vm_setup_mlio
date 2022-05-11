# Presentation

These scripts are used to setup AWS p3 isntances with NVIDIA V100 GPUs with the data and code to run the MLCommons image segmentation workload, and my BPF traces to analyze their execution and I/O patterns.

# Instructions

Before anything, login as root and add a git API token to `.bashrc` then do `source .bashrc`. 

Now, run `setupvm_p1.sh`. Follow the instructions given at the end to disable Xorg on boot and reboot the machine.
This script will download docker, nvidia drivers, etc.

Then run `setupvm_p2.sh` to download the raw dataset, build the docker image and preprocess the data. 

Once the second script terminates, you are ready to launch the workload.