#############################################################
#
# rund
#
#############################################################
RUND_VERSION:=v0.63
#RUND_GIT:=git://github.com/kurt-vd/rund
RUND_GIT:=git://www.vandijck-laurijssen.be/rund
#RUND_SOURCE:=rund-$(RUND_VERSION).tgz
#RUND_SITE:=http://www.vandijck-laurijssen.be/mirror
RUND_DIR:=$(BUILD_DIR)/rund
RUND_BINARY:=rund
RUND_TARGET_BINARY:=sbin/rund

rund-source: $(RUND_DIR)
$(RUND_DIR):
	mkdir -p $(dir $@)
	git clone $(RUND_GIT) $@
	cd $(RUND_DIR) && git checkout $(RUND_VERSION) && \
		git submodule init && git submodule update

rund-unpacked: rund-source
rund-configured:$(RUND_DIR)/config.mk
$(RUND_DIR)/config.mk: $(RUND_DIR)
	@echo "rund: prepare $(RUND_DIR)/config.mk"
	@echo "CFLAGS=$(TARGET_CFLAGS)" > $(RUND_DIR)/config.mk
	@echo "CC=$(TARGET_CC)" >> $(RUND_DIR)/config.mk
	@echo "LDFLAGS=-s" >> $(RUND_DIR)/config.mk
	@echo "LDLIBS=-lm" >> $(RUND_DIR)/config.mk
	@echo "PREFIX=" >> $(RUND_DIR)/config.mk
	@touch $@

$(RUND_DIR)/$(RUND_BINARY): $(RUND_DIR)/config.mk
	$(MAKE) -C $(RUND_DIR)
	@# tric to make this rund.mk work
	touch $@

$(TARGET_DIR)/$(RUND_TARGET_BINARY): $(RUND_DIR)/$(RUND_BINARY)
	$(MAKE) -C $(RUND_DIR) install DESTDIR=$(TARGET_DIR)
ifeq ($(BR2_PACKAGE_RUND_INIT),y)
	rm -f $(TARGET_DIR)/sbin/init
	ln -s rund $(TARGET_DIR)/sbin/init
endif
	$(INSTALL) -m 755 package/rund/rc.init $(TARGET_DIR)/etc/rc.init
	$(INSTALL) -m 755 package/rund/rc.shutdown $(TARGET_DIR)/etc/rc.shutdown

rund: uclibc $(TARGET_DIR)/$(RUND_TARGET_BINARY)

rund-clean:
	rm -f $(TARGET_DIR)/sbin/rund
	rm -f $(TARGET_DIR)/bin/runc
	rm -f $(TARGET_DIR)/bin/sockwait
	rm -f $(TARGET_DIR)/bin/ktstamp
ifeq ($(BR2_PACKAGE_RUND_INIT),y)
	rm -f $(TARGET_DIR)/sbin/init
endif
	-$(MAKE) -C $(RUND_DIR) clean

rund-dirclean:
	rm -rf $(RUND_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_RUND),y)
TARGETS+=rund
endif
