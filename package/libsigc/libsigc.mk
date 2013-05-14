#############################################################
#
# libsigc++
#
#############################################################
LIBSIGC_VERSION:=2.2.7
LIBSIGC_SITE:=http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.2/
LIBSIGC_SOURCE:=libsigc++-$(LIBSIGC_VERSION).tar.bz2
LIBSIGC_INSTALL_TARGET=YES
LIBSIGC_INSTALL_STAGING=YES
LIBSIGC_LIBTOOL_PATCH=NO

$(eval $(call AUTOTARGETS,package,libsigc))

