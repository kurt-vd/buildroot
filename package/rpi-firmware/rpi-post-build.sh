#!/bin/sh

cd ${TARGET_DIR}

# create /boot directory
mkdir -p ./boot

# add non-automatic mount entry
if ! grep -q " /boot " /etc/fstab; then
	echo "/dev/mmcblk0p1 /boot vfat defaults,noauto 0 0" >> ./etc/fstab
fi
