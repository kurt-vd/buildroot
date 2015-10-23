#############################################################
#
# inputevent
#
#############################################################
INPUTEVENT_VERSION:=r4
#INPUTEVENT_GIT:=git://github.com/kurt-vd/inputevent
INPUTEVENT_GIT:=git://www.vandijck-laurijssen.be/inputevent
INPUTEVENT_DIR:=$(BUILD_DIR)/inputevent
INPUTEVENT_BINARY:=inputevent
INPUTEVENT_TARGET_BINARY:=usr/bin/inputevent

inputevent-source: $(INPUTEVENT_DIR)
$(INPUTEVENT_DIR):
	mkdir -p $(dir $@)
	git clone $(INPUTEVENT_GIT) $@
	cd $(INPUTEVENT_DIR) && git checkout $(INPUTEVENT_VERSION)

inputevent-unpacked: inputevent-source
inputevent-configured:$(INPUTEVENT_DIR)/config.mk
$(INPUTEVENT_DIR)/config.mk: $(INPUTEVENT_DIR)
	@echo "inputevent: prepare $(INPUTEVENT_DIR)/config.mk"
	@echo "CFLAGS=$(TARGET_CFLAGS)" > $(INPUTEVENT_DIR)/config.mk
	@echo "CC=$(TARGET_CC)" >> $(INPUTEVENT_DIR)/config.mk
	@echo "PREFIX=/usr" >> $(INPUTEVENT_DIR)/config.mk
	@touch $@

$(INPUTEVENT_DIR)/$(INPUTEVENT_BINARY): $(INPUTEVENT_DIR)/config.mk
	$(MAKE) -C $(INPUTEVENT_DIR)
	@# tric to make this inputevent.mk work
	touch $@

$(TARGET_DIR)/$(INPUTEVENT_TARGET_BINARY): $(INPUTEVENT_DIR)/$(INPUTEVENT_BINARY)
	install -v $< $@

inputevent: uclibc $(TARGET_DIR)/$(INPUTEVENT_TARGET_BINARY)

inputevent-clean:
	rm -f $(TARGET_DIR)/$(INPUTEVENT_TARGET_BINARY)
ifeq ($(BR2_PACKAGE_INPUTEVENT_HA2),y)
	#rm -f $(TARGET_DIR)/sbin/init
endif
	-$(MAKE) -C $(INPUTEVENT_DIR) clean

inputevent-dirclean:
	rm -rf $(INPUTEVENT_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_INPUTEVENT),y)
TARGETS+=inputevent
endif
