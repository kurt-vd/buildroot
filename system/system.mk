
# persistentfs stuff
define PERSISTENTFS_HOOK
	$(INSTALL) -D -m755 system/persistentfs.rund $(TARGET_DIR)/etc/rc.local.d/05persistentfs; \
	sed -i -e "s,@@BLOCK@@,$(BR2_PERSISTENTFS),g" $(TARGET_DIR)/etc/rc.local.d/05persistentfs;
endef

ifneq ($(BR2_PERSISTENTFS),"")
	BR2_ROOTFS_POST_BUILD_SCRIPT += system/persistentfs-postbuild.sh
	TARGET_FINALIZE_HOOKS += PERSISTENTFS_HOOK
endif

