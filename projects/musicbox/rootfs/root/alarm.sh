#!/bin/sh

if [ "$#" != 2 ]; then
	echo "usage: $0 ALARM VALUE" >&2
	exit 1
fi

ALARM="$1"
VALUE="$2"
shift
shift

case "$ALARM:$VALUE" in
sleeptimer:on)
	mpc volume 80
	mplay 100 playlist "$ALARM"
	;;
*:on)
	mpc -q repeat off
	mpc -q consume on
	mpc -q volume 92

	mplay 100 playlist "$ALARM"
	;;
*)
	mpc -q pause
	;;
esac

