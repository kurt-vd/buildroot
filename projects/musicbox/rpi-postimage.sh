#!/bin/sh

IMGDIR="$1"
MYDIR=`dirname "$0"`

export PATH=$HOST_DIR/usr/bin:$HOST_DIR/bin:$PATH

rsync -auv $IMGDIR/rpi-firmware/ $IMGDIR/bootfs/

function put_or_patch {
	FILE="$1"

	if [ -f $MYDIR/$FILE ]; then
		echo "overwrite $FILE"
		cp $MYDIR/$FILE $IMGDIR/bootfs
	fi
	if [ -f $MYDIR/${FILE}.patch ]; then
		echo "patch $FILE"
		patch -p0 $IMGDIR/bootfs/$FILE < $MYDIR/${FILE}.patch
	fi
	if [ -f $MYDIR/${FILE}.sed ]; then
		echo "sed $FILE"
		sed -i -f $MYDIR/${FILE}.sed $IMGDIR/bootfs/$FILE
	fi
}

echo "Write kernel"
mkknlimg $IMGDIR/zImage $IMGDIR/bootfs/kernel.img

put_or_patch config.txt
put_or_patch cmdline.txt

if [ -f $IMGDIR/rootfs.cpio.lzo ]; then
	echo "Write initrd"
	cp $IMGDIR/rootfs.cpio.lzo $IMGDIR/bootfs
	if ! grep -q "^initrd" $IMGDIR/bootfs/config.txt; then
		echo "initrd rootfs.cpio.lzo 0x00a00000" >> $IMGDIR/bootfs/config.txt
	fi
fi

echo "Generate bootfs.tar"
tar -cf $IMGDIR/bootfs.tar -C $IMGDIR/bootfs/ .
