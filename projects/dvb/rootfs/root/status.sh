#!/bin/sh

PATH="/usr/sbin:/sbin:$PATH"

echo "== date =="
date
hwclock -r
echo "== uptime =="
uptime
echo "== dvb FE =="
dvbfemon | head -n1
