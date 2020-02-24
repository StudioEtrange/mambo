#!/bin/bash
# install nvidia driver without reboot
# on ubuntu server (no X11)

NVIDIA_DRIVER_VERSION="440.59"

apt update
apt install -y build-essential

# download nvidia driver
wget "https://download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_DRIVER_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run" -O "/tmp/NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run"
chmod +x "/tmp/NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run"

# disable nouveau driver
#echo "blacklist nouveau" | tee /etc/modprobe.d/blacklist-nouveau.conf # already blacklisted by nvidia installer
echo 0 | tee /sys/class/vtconsole/vtcon1/bind
rmmod nouveau
rmmod ttm
rmmod drm_kms_helper
rmmod drm
q
# install nvidia-driver
/tmp/NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run --silent --disable-nouveau


nvidia-smi