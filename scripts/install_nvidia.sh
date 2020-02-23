#!/bin/bash
NVIDIA_DRIVER_VERSION="440.59"

apt update
apt install build-essential
echo "blacklist nouveau" | sudo tee /etc/modprobe.d/blacklist.conf
modprobe -r nouveau
wget "https://download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_DRIVER_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run" -O "/tmp/NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run"
chmod +x "/tmp/NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run"
/tmp/NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run --silent


