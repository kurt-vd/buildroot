################################################################################
#
# mksh
#
################################################################################

MKSH_VERSION = R52c
MKSH_SOURCE = mksh-$(MKSH_VERSION).tgz
MKSH_SITE = https://www.mirbsd.org/MirOS/dist/mir/mksh
MKSH_LICENSE = MirOS, BSD-3c, ISC
MKSH_LICENSE_FILES = COPYING

define MKSH_CONFIGURE_CMDS
	cd $(@D) && $(TARGET_MAKE_ENV) \
		CPPFLAGS="-DMKSH_S_NOVI=0 $(TARGET_CPPFLAGS)" \
		CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" \
		LD="$(TARGET_LD)" LDFLAGS="$(TARGET_LDFLAGS)" LDLIBS="$(TARGET_LDLIBS)" \
		TARGET_OS=Linux \
		sh ./Build.sh -M
endef

define MKSH_BUILD_CMDS
	cd $(@D) && $(TARGET_MAKE_ENV) \
		sh ./Rebuild.sh
endef

define MKSH_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/mksh $(TARGET_DIR)/bin/mksh
endef

$(eval $(generic-package))
