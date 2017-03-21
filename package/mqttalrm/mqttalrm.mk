################################################################################
#
# mqttalrm
#
################################################################################

MQTTALRM_VERSION = r7
MQTTALRM_SITE = $(call github,kurt-vd,mqttalrm,$(MQTTALRM_VERSION))
MQTTALRM_LICENSE = GPLv3
MQTTALRM_LICENSE_FILES = COPYING

MQTTALRM_LDLIBS += -lmosquitto
MQTTALRM_LDFLAGS += -lmosquitto
MQTTALRM_CFLAGS +=  -D_GNU_SOURCE

define MQTTALRM_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) LOCALVERSION=$(MQTTALRM_VERSION) $(TARGET_CONFIGURE_OPTS)
endef

ifdef BR2_PACKAGE_MQTTALRM_WEBGUI
define MQTTALRM_INSTALL_STATIC_FILES
	mkdir -p $(TARGET_DIR)/var/www
	cp $(@D)/alarm.html $(TARGET_DIR)/var/www/
endef
endif

define MQTTALRM_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install INSTOPTS= DESTDIR="$(TARGET_DIR)" PREFIX=/usr $(TARGET_CONFIGURE_OPTS)
	$(MQTTALRM_INSTALL_STATIC_FILES)
endef

$(eval $(generic-package))
