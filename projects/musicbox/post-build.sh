#!/bin/sh

cd ${TARGET_DIR}

if [ -d var/www ]; then
	echo "move /var/www to /usr/share/www"
	rsync -auv var/www/ usr/share/www/
	rm -rf var/www
fi

for HTML in usr/share/www/*.html; do
	echo "process $HTML"
	grep "script src=" "$HTML" | sed -e "s/^.*script src=[\"']\([^\"']*\)[\"'].*$/\1/g" | grep ^http | while read JS; do
		LOCALJS=js/`basename "$JS"`
		LOCALJSFILE="usr/share/www/$LOCALJS"
		mkdir -p `dirname "$LOCALJSFILE"`
		if [ ! -f "$LOCALJSFILE" ]; then
			echo "download local copy for $JS"
			wget -q "$JS" -O "$LOCALJSFILE"
		fi
		sed -e "s;$JS;$LOCALJS;g" -i "$HTML"
	done
done

