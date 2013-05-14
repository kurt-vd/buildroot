#############################################################
#
# Wireshark Network analyzer
#
#############################################################
WIRESHARK_VERSION:=1.2.2
WIRESHARK_SOURCE:=wireshark-$(WIRESHARK_VERSION).tar.bz2
WIRESHARK_SITE:=http://media-2.cacatech.com/wireshark/src/
WIRESHARK_INSTALL_TARGET=YES
WIRESHARK_DEPENDENCIES=libgtk2 libpcap
WIRESHARK_CONF_OPT:=--disable-usr-local
WIRESHARK_INSTALL_TARGET_OPT=DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package,wireshark))
