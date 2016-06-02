################################################################################
#
# cgiformhelper
#
################################################################################

CGIFORMHELPER_VERSION = r2
CGIFORMHELPER_SITE = git://github.com/kurt-vd/cgiformhelper.git
CGIFORMHELPER_LICENSE = GPLv3
CGIFORMHELPER_LICENSE_FILES = LICENSE

define CGIFORMHELPER_CONFIGURE_CMDS
	echo "PREFIX=/usr" > $(@D)/config.mk
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

define CGIFORMHELPER_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define CGIFORMHELPER_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install DESTDIR="$(TARGET_DIR)"
endef

$(eval $(generic-package))
