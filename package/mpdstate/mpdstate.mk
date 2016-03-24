################################################################################
#
# mpdstate
#
################################################################################

MPDSTATE_VERSION = r3
#MPDSTATE_SITE = git://github.com/kurt-vd/mpdstate.git
MPDSTATE_SITE = $(call github,kurt-vd,mpdstate,$(MPDSTATE_VERSION))
MPDSTATE_LICENSE = GPLv3
MPDSTATE_LICENSE_FILES = LICENSE

define MPDSTATE_CONFIGURE_CMDS
	echo "PREFIX=/" > $(@D)/config.mk
	echo "CFLAGS=$(TARGET_CFLAGS)" >> $(@D)/config.mk
	echo "CPPFLAGS=$(TARGET_CPPFLAGS)" >> $(@D)/config.mk
	echo "CXXFLAGS=$(TARGET_CXXFLAGS)" >> $(@D)/config.mk
	echo "LDFLAGS=$(TARGET_LDFLAGS)" >> $(@D)/config.mk
	echo "LDLIBS+=$(TARGET_LDLIBS)" >> $(@D)/config.mk
	echo "CC=$(TARGET_CC)" >> $(@D)/config.mk
	echo "CXX=$(TARGET_CXX)" >> $(@D)/config.mk
	echo "LD=$(TARGET_LD)" >> $(@D)/config.mk
	echo "AS=$(TARGET_AS)" >> $(@D)/config.mk

	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) clean
endef

define MPDSTATE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define MPDSTATE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install DESTDIR="$(TARGET_DIR)"
endef

$(eval $(generic-package))
