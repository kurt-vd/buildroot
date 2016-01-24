################################################################################
#
# rund
#
################################################################################

RUND_VERSION = 8e82634d4a05426b2380f59ceba491187e1a71e5
RUND_SITE = $(call github,kurt-vd,rund,$(RUND_VERSION))
RUND_LICENSE = GPLv3
RUND_LICENSE_FILES = LICENSE

define RUND_CONFIGURE_CMDS
	echo "PREFIX=/" > $(@D)/config.mk
	echo "CFLAGS=$(TARGET_CFLAGS)" >> $(@D)/config.mk
	echo "CPPFLAGS=-D_GNU_SOURCE $(TARGET_CPPFLAGS)" >> $(@D)/config.mk
	echo "CXXFLAGS=$(TARGET_CXXFLAGS)" >> $(@D)/config.mk
	echo "LDFLAGS=$(TARGET_LDFLAGS)" >> $(@D)/config.mk
	echo "LDLIBS=$(TARGET_LDLIBS)" >> $(@D)/config.mk
	echo "CC=$(TARGET_CC)" >> $(@D)/config.mk
	echo "CXX=$(TARGET_CXX)" >> $(@D)/config.mk
	echo "LD=$(TARGET_LD)" >> $(@D)/config.mk
	echo "AS=$(TARGET_AS)" >> $(@D)/config.mk

	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) clean
endef

define RUND_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

# determint device manager
ifdef BR2_ROOTFS_DEVICE_CREATION_STATIC
DEVMAN=none
endif
ifdef BR2_ROOTFS_DEVICE_CREATION_DYNAMIC_DEVTMPFS
DEVMAN=devtmpfs
endif
ifdef BR2_ROOTFS_DEVICE_CREATION_DYNAMIC_MDEV
DEVMAN=mdev
endif
ifdef BR2_ROOTFS_DEVICE_CREATION_DYNAMIC_EUDEV
DEVMAN=udev
endif

define RUND_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install DESTDIR="$(TARGET_DIR)"
	# install /sbin/init symlink
	if [ "$(BR2_INIT_RUND)" = "y" ]; then \
		rm -f $(TARGET_DIR)/sbin/init; \
		ln -s rund $(TARGET_DIR)/sbin/init; \
	fi
	# install /sbin/shutdown etc links
	if [ "$(BR2_PACKAGE_RUND_HALT)" = "y" ]; then \
		$(INSTALL) -v $(@D)/shutdown $(TARGET_DIR)/sbin/shutdown; \
		for cmd in halt reboot poweroff; do \
			rm -f $(TARGET_DIR)/sbin/$${cmd}; \
			ln -s shutdown $(TARGET_DIR)/sbin/$${cmd}; \
		done; \
	fi
	# install init/shutdown scripts
	$(INSTALL) -m 755 package/rund/rc.init $(TARGET_DIR)/etc/rc.init
	$(INSTALL) -m 755 package/rund/rc.shutdown $(TARGET_DIR)/etc/rc.shutdown
	$(INSTALL) -d $(TARGET_DIR)/etc/rc.local.d
	# start getty
	if [ $(BR2_TARGET_GENERIC_GETTY) = "y" ]; then \
		sed -i $(TARGET_DIR)/etc/rc.init \
		-e "s,ttyS0,$(BR2_TARGET_GENERIC_GETTY_PORT),g" \
		-e "s,115200,$(BR2_TARGET_GENERIC_GETTY_BAUDRATE),g" \
		-e "s,vt100,$(BR2_TARGET_GENERIC_GETTY_TERM),g" \
		; \
	fi
	# delete every other device manager from rc.init
	sed -i $(TARGET_DIR)/etc/rc.init \
		-e "/## DEVICE MANAGER START/,/## $(DEVMAN) START/ d" \
		-e "/## $(DEVMAN) DONE/,/## DEVICE MANAGER DONE/ d" \
		-e "/## DEVICE MANAGER START/,/## DEVICE MANAGER DONE/ d"
endef

$(eval $(generic-package))
#$(eval $(configmk-package))
