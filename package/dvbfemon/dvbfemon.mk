################################################################################
#
# dvbfemon
#
################################################################################

DVBFEMON_VERSION = r1
DVBFEMON_SITE = $(call github,kurt-vd,dvbfemon,$(DVBFEMON_VERSION))
DVBFEMON_LICENSE = GPLv3
DVBFEMON_LICENSE_FILES = LICENSE

define DVBFEMON_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define DVBFEMON_INSTALL_TARGET_CMDS
	$(INSTALL) $(@D)/dvbfemon $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
