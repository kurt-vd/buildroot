################################################################################
#
# networktest
#
################################################################################

NETWORKTEST_VERSION = v0.5
NETWORKTEST_LICENSE = GPLv3
NETWORKTEST_LICENSE_FILES = LICENSE

define NETWORKTEST_CONFIGURE_CMDS
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

	echo "CPPFLAGS+=-DNO_PBUS" >> $(@D)/config.mk
endef

define NETWORKTEST_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define NETWORKTEST_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/sbin
	$(INSTALL) $(@D)/networktest2 $(TARGET_DIR)/usr/sbin
endef

$(eval $(generic-package))
#$(eval $(configmk-package))
