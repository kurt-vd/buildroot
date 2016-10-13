
# persistentfs stuff
define PERSISTENTFS_HOOK
	$(INSTALL) -D -m755 system/persistentfs.sh $(TARGET_DIR)/etc/persistentfs.sh; \
	sed -i \
		-e s,@@BLOCKDEVS@@,$(BR2_PERSISTENTFS),g \
		-e s,@@DIRS@@,$(BR2_PERSISTENTFSDIRS),g \
		-e s,@@DIRS_AUTO@@,"$(BR2_PERSISTENTFSDIRS_AUTO)",g \
		$(TARGET_DIR)/etc/persistentfs.sh;
endef

ifneq ($(BR2_PERSISTENTFS),"")
	TARGET_FINALIZE_HOOKS += PERSISTENTFS_HOOK
endif

