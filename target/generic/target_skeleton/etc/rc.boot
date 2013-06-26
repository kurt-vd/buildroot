#!/bin/sh

mount -tproc proc /proc
mount -tsysfs sys /sys
mount -ttmpfs tmp /tmp
mount -tdevtmpfs dev /dev
mkdir -p /dev/pts
mount -tdevpts devpts /dev/pts

ip link set lo up
#ip addr add 127.0.0.1/8 dev lo

hostname -F /etc/hostname

echo heartbeat > /sys/class/leds/power/trigger

echo "setup GPIO"
echo 13 > /sys/class/gpio/export
echo 30 > /sys/class/gpio/export
echo low > /sys/class/gpio/gpio30/direction

ip link set eth0 up
udhcpc -qi eth0 &

ip link set usb0 up
ip addr add 192.168.255.1/24 dev usb0
udhcpd /etc/udhcpd-usb0.conf &
