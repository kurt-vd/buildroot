#!/bin/sh

# list services & start all of them
@PRESET@.sh services | while read SVC; do
	runc add @PRESET@.sh $SVC
done
