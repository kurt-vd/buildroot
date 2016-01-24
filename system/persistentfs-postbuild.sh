#!/bin/sh

# determine the relative path from FROM ($1) to TO ($2)
# The returned path (if any) is usable as destination for
# symlinking.
relative_path() {
	FROM="$1"
	TO="$2"

	RESULT=
	until [ "$FROM" = "." ]; do
		FROM=`dirname "$FROM"`

		TMPTO="$TO"
		#echo "TRY FROM=$FROM"
		until [ "$TMPTO" = "." ]; do
			TMPTO=`dirname "$TMPTO"`
			#echo "TRY TO=$TMPTO"
			if [ "$FROM" = "$TMPTO" ]; then
				echo $RESULT`echo "$TO" | sed -e "s,^$FROM/,,g"`
				return
			fi
		done
		RESULT="../$RESULT"
	done
}

persistentfs_hook() {
	cd ${TARGET_DIR}
	# prepare for some non-directory stuff
	touch etc/machine-id

	SPECIAL_FILES="etc/machine-id etc/wpa_supplicant.conf"
	# stuff into var/persistent
	mkdir -p var/persistent
	for DIR in root var/cache var/log var/spool var/lib var/tmp \
		etc/dropbear \
		$SPECIAL_FILES; do
		if [ -L $DIR ]; then
			rm $DIR
			# create the directory is the name does not exist
			# this avoids warnings on etc/machine-id
			if ! [ -f var/persistent/$DIR ]; then
				mkdir -p var/persistent/$DIR
			fi
		elif [ -e $DIR ]; then
			mkdir -p `dirname var/persistent/$DIR`
			mv $DIR var/persistent/$DIR
		else
			mkdir -p var/persistent/$DIR
		fi
		# symlink to absolute path is not feasible for the other postinstall scripts.
		# they may end up in the host local filesystem.
		#ln -s /var/persistent/$DIR $DIR
		# Rather find the relative path
		TO=`relative_path "$DIR" "var/persistent/$DIR"`
		if [ -z "$TO" ]; then
			# assign absolute path
			TO="/var/persistent/$DIR"
		fi
		echo "symlink $DIR $TO" >&2
		ln -s $TO $DIR
	done
}

persistentfs_hook
