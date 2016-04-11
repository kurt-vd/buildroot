#!/bin/sh

echo "[`ktstamp -k`] start @PRESET@"
# list services & start all of them
for SVC in `@PRESET@.sh services`; do
	runc add @PRESET@.sh $SVC
done
