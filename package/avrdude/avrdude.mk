AVRDUDE_VERSION:=5.8
AVRDUDE_SITE:=http://mirrors.zerg.biz/nongnu/avrdude/
AVRDUDE_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package,avrdude))
