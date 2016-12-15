#!/bin/sh

PATH="/usr/sbin:/sbin:$PATH"

echo "== date =="
date
hwclock -r
echo "== uptime =="
uptime
echo "== hardware =="
TEMP=`cat /sys/devices/virtual/thermal/thermal_zone0/temp`
TEMP=$(( $TEMP / 1000))
# this line misbehaves on target vi due to utf-8 character
echo "temp $TEMP°C"
echo "== mpd =="
mpc status
