#!/bin/sh

IMGDIR="$1"
EXTRADIR=`grep "^BR2_PACKAGE_RPI_FIRMWARE_EXTRA_PATH=" $BR2_CONFIG | sed -e "s,^.*=,,g" -e "s,\",,g"`

export PATH=$HOST_DIR/usr/bin:$HOST_DIR/bin:$PATH

rm -rf $IMGDIR/bootfs
rsync -auv $IMGDIR/rpi-firmware/ $IMGDIR/bootfs/

function put_or_patch {
	FILE="$1"

	if [ -f $EXTRADIR/$FILE ]; then
		echo "overwrite $FILE"
		cp $EXTRADIR/$FILE $IMGDIR/bootfs
	fi
	if [ -f $EXTRADIR/${FILE}.patch ]; then
		echo "patch $FILE"
		patch -p0 $IMGDIR/bootfs/$FILE < $EXTRADIR/${FILE}.patch
	fi
	if [ -f $EXTRADIR/${FILE}.sed ]; then
		echo "sed $FILE"
		sed -i -f $EXTRADIR/${FILE}.sed $IMGDIR/bootfs/$FILE
	fi
}

function install_extra_dtb_overlays
{
	DTC=`ls output/build/linux-*/scripts/dtc/dtc | head -n1`
	if ! [ -x $DTC ]; then
		DTC=dtc
	else
		echo "Using $DTC"
	fi
	for DTS in $EXTRADIR/*-overlay.dts; do
		DTSNAME=`basename ${DTS%%.dts}`
		echo "Compile $DTSNAME"
		$DTC -@ -O dtb $DTS -o $IMGDIR/bootfs/overlays/${DTSNAME}.dtb
	done
}

if [ -d "$EXTRADIR" ]; then
	echo "merge $EXTRADIR"
	put_or_patch config.txt
	put_or_patch cmdline.txt
	install_extra_dtb_overlays
fi

echo "Write kernel"
mkknlimg $IMGDIR/zImage $IMGDIR/bootfs/kernel.img
sed -i -e "s/^.*kernel=.*$/kernel=kernel.img/g" $IMGDIR/bootfs/config.txt

echo "Write devicetree's"
rsync -auv $IMGDIR/*.dtb $IMGDIR/bootfs/

if [ -f $IMGDIR/rootfs.cpio.lzo ]; then
	echo "Write initrd"
	cp $IMGDIR/rootfs.cpio.lzo $IMGDIR/bootfs
	sed -i -e "s/^#initramfs.*$/initramfs rootfs.cpio.lzo/" $IMGDIR/bootfs/config.txt
fi

echo "Generate bootfs.tar"
tar -cf $IMGDIR/bootfs.tar -C $IMGDIR/bootfs/ .
