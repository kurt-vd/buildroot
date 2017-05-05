#!/bin/sh

IMGDIR="$1"
EXTRADIR=`grep "^BR2_PACKAGE_RPI_FIRMWARE_EXTRA_PATH=" $BR2_CONFIG | sed -e "s,^.*=,,g" -e "s,\",,g"`

export PATH=$HOST_DIR/usr/bin:$HOST_DIR/bin:$PATH

function put_or_patch {
	FILE="$1"

	if [ -f $EXTRADIR/$FILE ]; then
		echo "overwrite $FILE"
		cp $EXTRADIR/$FILE $IMGDIR/rpi-firmware
	fi
	if [ -f $EXTRADIR/${FILE}.patch ]; then
		echo "patch $FILE"
		patch -p0 $IMGDIR/rpi-firmware/$FILE < $EXTRADIR/${FILE}.patch
	fi
	if [ -f $EXTRADIR/${FILE}.sed ]; then
		echo "sed $FILE"
		sed -i -f $EXTRADIR/${FILE}.sed $IMGDIR/rpi-firmware/$FILE
	fi
}

function install_extra_dtb_overlays
{
	DTC=`ls output/build/linux-*/scripts/dtc/dtc | head -n1`
	if ! [ -x $DTC ]; then
		DTC=dtc
	else
		echo "devicetree: Using $DTC"
	fi
	for DTS in $EXTRADIR/*-overlay.dts; do
		DTSNAME=`basename ${DTS%%-overlay.dts}`
		echo "devicetree: Compile $DTSNAME"
		$DTC -@ -O dtb $DTS -o $IMGDIR/rpi-firmware/overlays/${DTSNAME}.dtbo
	done
}

if [ -d "$EXTRADIR" ]; then
	echo "merge $EXTRADIR"
	put_or_patch config.txt
	put_or_patch cmdline.txt
	install_extra_dtb_overlays
fi

echo "Write kernel"
#perl package/rpi-firmware/mkknlimg $IMGDIR/zImage $IMGDIR/rpi-firmware/zImage
cp $IMGDIR/zImage $IMGDIR/rpi-firmware/zImage
# find+copy smallest initramfs
RAMFS=`cd ${IMGDIR}; \ls -rSL rootfs.cpio.* 2>/dev/null | head -n1`
if [ -n "$RAMFS" ]; then
	echo "Copy $RAMFS"
	cp $IMGDIR/$RAMFS $IMGDIR/rpi-firmware/
	sed -i -e "s/^#initramfs.*$/initramfs $RAMFS/" $IMGDIR/rpi-firmware/config.txt
else
	sed -i -e "s/^initramfs/#initramfs/" $IMGDIR/rpi-firmware/config.txt
fi
echo "Copy device trees"
cp $IMGDIR/*.dtb $IMGDIR/rpi-firmware/
