#!/bin/sh

if [ "$#" != 2 ]; then
	echo "usage: $0 ALARM VALUE" >&2
	exit 1
fi

VOLHI=92
VOLLO=80

if [ -f /root/config ]; then
	. /root/config
fi

ALARM="$1"
VALUE="$2"
shift
shift

case "$ALARM:$VALUE" in
sleeptimer:1)
	mpc -q volume $VOLLO
	mplay 100 playlist "$ALARM"
	;;
sleeptimer:0)
	# play current song, no more
	mpc -q crop
	# add 1 goodnight song
	mplay 1 playlist "zn3"
	;;
stilletjes:1)
	mpc -q volume $VOLLO
	;;
stilletjes:0)
	mpc -q volume $VOLHI
	;;
*:1)
	mpc -q repeat off
	mpc -q consume on
	mpc -q volume $VOLHI

	mplay 100 playlist "$ALARM"
	;;
*:0|*:snoozed)
	mpc -q pause
	;;
esac

