#!/bin/sh

mount -tproc proc /proc
mount -tsysfs sys /sys
mount -ttmpfs tmp /tmp
mount -tdevpts devpts /dev/pts

ip link set lo up
#ip addr add 127.0.0.1/8 dev lo

hostname -F /etc/hostname

echo heartbeat > /sys/class/leds/power/trigger

echo "setup GPIO"
echo 13 > /sys/class/gpio/export
echo 30 > /sys/class/gpio/export

ip link set eth0 up
udhcpc -qi eth0 &
