SQLITEDBMS_VERSION:=0.5.1
SQLITEDBMS_AUTORECONF:=YES

SQLITEDBMS_INSTALL_STAGING:=YES
SQLITEDBMS_DEPENDENCIES:=sqlite

SQLITEDBMS_MAKE_ENV:=DATADIR=/usr/share/sqlitedbms
SQLITEDBMS_CONF_ENV:=ac_cv_func_malloc_0_nonnull=yes
SQLITEDBMS_CONF_ENV+=ac_cv_func_realloc_0_nonnull=yes

$(eval $(call AUTOTARGETS,package/database,sqlitedbms))

SQLITEDBMS_INSTALL_TARGET_OPTS += install-data
ifeq ($(BR2_HAVE_DOCUMENTATION),y)
SQLITEDBMS_INSTALL_TARGET_OPTS += install-htdocs
endif
