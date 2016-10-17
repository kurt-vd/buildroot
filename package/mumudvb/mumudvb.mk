################################################################################
#
# mumudvb
#
################################################################################

MUMUDVB_VERSION = 2.0.0
MUMUDVB_SITE = $(call github,braice,mumudvb,$(MUMUDVB_VERSION))
MUMUDVB_LICENSE = GPLv2
MUMUDVB_LICENSE_FILES = COPYING

MUMUDVB_AUTORECONF=YES

$(eval $(autotools-package))
