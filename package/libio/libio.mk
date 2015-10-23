#############################################################
#
# libio
#
#############################################################
LIBIO_VERSION:=v20151023
#LIBIO_GIT:=git://github.com/kurt-vd/libio
LIBIO_GIT:=git://www.vandijck-laurijssen.be/libio
#LIBIO_SOURCE:=libio-$(LIBIO_VERSION).tgz
#LIBIO_SITE:=http://www.vandijck-laurijssen.be/mirror
LIBIO_DIR:=$(BUILD_DIR)/libio
LIBIO_BINARY:=io
LIBIO_TARGET_BINARY:=usr/bin/io

libio-source: $(LIBIO_DIR)
$(LIBIO_DIR):
	mkdir -p $(dir $@)
	git clone $(LIBIO_GIT) $@
	cd $(LIBIO_DIR) && git checkout $(LIBIO_VERSION) && \
		git submodule init && git submodule update

libio-unpacked: libio-source
libio-configured:$(LIBIO_DIR)/config.mk
$(LIBIO_DIR)/config.mk: $(LIBIO_DIR)
	@echo "libio: prepare $(LIBIO_DIR)/config.mk"
	@echo "CFLAGS=$(TARGET_CFLAGS)" > $(LIBIO_DIR)/config.mk
	@echo "CC=$(TARGET_CC)" >> $(LIBIO_DIR)/config.mk
	@echo "PREFIX=/usr" >> $(LIBIO_DIR)/config.mk
	@touch $@

$(LIBIO_DIR)/$(LIBIO_BINARY): $(LIBIO_DIR)/config.mk
	$(MAKE) -C $(LIBIO_DIR)
	@# tric to make this libio.mk work
	touch $@

$(TARGET_DIR)/$(LIBIO_TARGET_BINARY): $(LIBIO_DIR)/$(LIBIO_BINARY)
	install -v $(wildcard $(LIBIO_DIR)/*.sh) $(TARGET_DIR)/usr/bin
	install -v -d $(TARGET_DIR)/usr/share/libio
	install -v -m 0644 $(wildcard $(LIBIO_DIR)/*.conf) $(TARGET_DIR)/usr/share/libio
ifneq ($(BR2_PACKAGE_LIBIO_PRESET),)
	sed -e "s,@PRESET@,$(BR2_PACKAGE_LIBIO_PRESET),g" package/libio/libio.conf > $(TARGET_DIR)/etc/libio.conf
ifeq ($(BR2_PACKAGE_RUND),y)
	install -d $(TARGET_DIR)/etc/run.d
	install package/libio/libio-start.sh $(TARGET_DIR)/etc/run.d/S80libio
	sed -i -e "s,@PRESET@,$(BR2_PACKAGE_LIBIO_PRESET),g" $(TARGET_DIR)/etc/run.d/S80libio
endif
endif
	install -v $(LIBIO_DIR)/io $(TARGET_DIR)/usr/bin

libio: uclibc $(TARGET_DIR)/$(LIBIO_TARGET_BINARY)

libio-clean:
	rm -f $(TARGET_DIR)/$(LIBIO_TARGET_BINARY)
ifeq ($(BR2_PACKAGE_LIBIO_HA2),y)
	#rm -f $(TARGET_DIR)/sbin/init
endif
	-$(MAKE) -C $(LIBIO_DIR) clean

libio-dirclean:
	rm -rf $(LIBIO_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_LIBIO),y)
TARGETS+=libio
endif
