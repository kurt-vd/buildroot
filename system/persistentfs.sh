#!/bin/sh

if [ -d /nv ]; then
	TMPDIR=/nv
else
	TMPDIR=/tmp/dat-$$
	mkdir -p "$TMPDIR"
fi

mount_vardat() {
	DATDEV="$1"
	if ! [ -b "$DATDEV" ]; then
		return 1;
	fi
	if mount "$DATDEV" "$TMPDIR"; then
		return 0
	fi
	echo "[dat] mount $DATDEV failed, re-create filesystem"
	if ! mkfs.ext3 $DATDEV; then
		echo "[dat] mkfs.ext3 $DATDEV failed"
		return 1;
	fi
	if ! mount "$DATDEV" "$TMPDIR"; then
		echo "[dat] mount $DATDEV failed!"
		return 1;
	fi
	return 0
}

for DEV in @@BLOCKDEVS@@; do
	if mount_vardat "$DEV"; then
		echo "[dat] mounted $DEV"
		break;
	fi
done

if ! grep " $TMPDIR " /proc/mounts > /dev/null; then
	echo "[dat] mount TMP"
	mount -t tmpfs dat "$TMPDIR"
fi

if [ -f "${TMPDIR}/etc/hostname" ]; then
	hostname -F "${TMPDIR}/etc/hostname"
fi

for DIR in @@DIRS@@ @@DIRS_AUTO@@; do
	PARENT=`dirname "${TMPDIR}/${DIR}"`
	# make sure the directory exists (important on new filesystem)
	mkdir -p "${PARENT}"
	# rsync missing files
	rsync -au --ignore-existing "/$DIR" "${PARENT}/"
	# put in place
	mount --bind "${TMPDIR}/${DIR}" "/$DIR"
done

if [ "$TMPDIR" != /nv ]; then
	umount "$TMPDIR"
	rmdir -f "$TMPDIR"
fi
