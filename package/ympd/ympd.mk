################################################################################
#
# ympd
#
################################################################################

YMPD_VERSION = v1.3.0
YMPD_SITE = $(call github,notandy,ympd,$(YMPD_VERSION))
YMPD_LICENSE = GPLv2
YMPD_LICENSE_FILES = LICENSE
YMPD_DEPENDENCIES = libmpdclient

$(eval $(cmake-package))
