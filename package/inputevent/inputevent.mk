################################################################################
#
# inputevent
#
################################################################################

INPUTEVENT_VERSION = r7
INPUTEVENT_SITE = git://github.com/kurt-vd/inputevent.git
#INPUTEVENT_SITE = $(call github,kurt-vd,rund,$(INPUTEVENT_VERSION))
INPUTEVENT_LICENSE = GPLv3
INPUTEVENT_LICENSE_FILES = LICENSE

define INPUTEVENT_CONFIGURE_CMDS
	echo "PREFIX=/" > $(@D)/config.mk
	echo "CFLAGS=$(TARGET_CFLAGS)" >> $(@D)/config.mk
	echo "CPPFLAGS=-D_GNU_SOURCE $(TARGET_CPPFLAGS)" >> $(@D)/config.mk
	echo "CXXFLAGS=$(TARGET_CXXFLAGS)" >> $(@D)/config.mk
	echo "LDFLAGS=$(TARGET_LDFLAGS)" >> $(@D)/config.mk
	echo "LDLIBS+=$(TARGET_LDLIBS)" >> $(@D)/config.mk
	echo "CC=$(TARGET_CC)" >> $(@D)/config.mk
	echo "CXX=$(TARGET_CXX)" >> $(@D)/config.mk
	echo "LD=$(TARGET_LD)" >> $(@D)/config.mk
	echo "AS=$(TARGET_AS)" >> $(@D)/config.mk

	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) clean
endef

define INPUTEVENT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define INPUTEVENT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install DESTDIR="$(TARGET_DIR)"
endef

$(eval $(generic-package))
#$(eval $(configmk-package))
