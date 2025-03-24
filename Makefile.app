##----------------------------------------------------------------------
## DISCLAIMER
##
## This file contains the rules to make an Eliom project. The project is
## configured through the variables in the file Makefile.options.
##----------------------------------------------------------------------

##----------------------------------------------------------------------
##                Internals

## Generate js_of_eliom runtime options
JSOPT_RUNTIMES := $(addprefix -jsopt +,${JS_RUNTIMES})

## Required binaries
OCSIGENSERVER     := ocsigenserver
OCSIGENSERVER.OPT := ocsigenserver.opt
OCAMLFORMAT       := ocamlformat

## Where to put intermediate object files.
## - ELIOM_{SERVER,CLIENT}_DIR must be distinct
## - ELIOM_CLIENT_DIR must not be the local dir.
## - ELIOM_SERVER_DIR could be ".", but you need to
##   remove it from the "clean" rules...
export ELIOM_SERVER_DIR := _server
export ELIOM_CLIENT_DIR := _client
export ELIOM_TYPE_DIR   := _server

DEPSDIR := _deps

ifeq ($(DEBUG),yes)
  GENERATE_DEBUG ?= -g
  RUN_DEBUG ?= "-vvv"
  DEBUG_JS ?= -jsopt --pretty -jsopt --noinline -jsopt --debuginfo
endif

##----------------------------------------------------------------------
## General

.PHONY: all byte opt

all:: byte opt

DIST_DIRS          := $(ETCDIR) $(DATADIR) $(LIBDIR) $(LOGDIR) \
		      $(STATICFILESDIR) $(ELIOMSTATICDIR) \
		      $(shell dirname $(CMDPIPE))

CONF_IN           := $(PROJECT_NAME).conf.in
CONFIG_FILE       := $(TEST_PREFIX)$(ETCDIR)/$(PROJECT_NAME).conf
TEST_CONFIG_FILE  := $(TEST_PREFIX)$(ETCDIR)/$(PROJECT_NAME)-test.conf

SEXP_IN           := $(PROJECT_NAME).sexp
SEXP_FILE         := $(TEST_PREFIX)$(ETCDIR)/$(PROJECT_NAME).sexp

byte opt:: $(TEST_PREFIX)$(ELIOMSTATICDIR)/${PROJECT_NAME}.js
byte opt:: $(CONFIG_FILE)
byte opt:: $(TEST_CONFIG_FILE)
byte opt:: $(SEXP_FILE)
byte:: $(TEST_PREFIX)$(LIBDIR)/${PROJECT_NAME}.cma
opt:: $(TEST_PREFIX)$(LIBDIR)/${PROJECT_NAME}.cmxs

##----------------------------------------------------------------------
## Testing

DIST_FILES = $(ELIOMSTATICDIR)/$(PROJECT_NAME).js $(LIBDIR)/$(PROJECT_NAME).cma

.PHONY: test.byte test.opt

test.byte:: byte | $(addprefix $(TEST_PREFIX),$(DIST_DIRS))
	$(OCSIGENSERVER) $(RUN_DEBUG) -c $(TEST_CONFIG_FILE)

test.opt:: opt | $(addprefix $(TEST_PREFIX),$(DIST_DIRS))
	$(OCSIGENSERVER.OPT) $(RUN_DEBUG) -c $(TEST_CONFIG_FILE)

$(addprefix $(TEST_PREFIX), $(DIST_DIRS)):
	mkdir -p $@

##----------------------------------------------------------------------
## Installing & Running

.PHONY: install install.byte install.byte install.opt install.static install.etc install.lib install.lib.byte install.lib.opt run.byte run.opt
install-unit:
	cp pmp6-site.service /etc/systemd/system
install: install.byte install.opt
install.byte: byte install.lib.byte install.etc install.static | $(addprefix $(PREFIX),$(DATADIR) $(LOGDIR) $(shell dirname $(CMDPIPE)))
install.opt: opt install.lib.opt install.etc install.static | $(addprefix $(PREFIX),$(DATADIR) $(LOGDIR) $(shell dirname $(CMDPIPE)))
install.lib: install.lib.byte install.lib.opt
install.lib.byte: $(TEST_PREFIX)$(LIBDIR)/$(PROJECT_NAME).cma | $(PREFIX)$(LIBDIR)
	install $< $(PREFIX)$(LIBDIR)
install.lib.opt: $(TEST_PREFIX)$(LIBDIR)/$(PROJECT_NAME).cmxs | $(PREFIX)$(LIBDIR)
	install $< $(PREFIX)$(LIBDIR)
install.static: $(TEST_PREFIX)$(ELIOMSTATICDIR)/$(PROJECT_NAME).js | $(PREFIX)$(STATICFILESDIR) $(PREFIX)$(ELIOMSTATICDIR)
	cp -r $(LOCAL_STATIC)/* $(PREFIX)$(STATICFILESDIR)
	[ -z $(WWWUSER) ] || chown -R $(WWWUSER):$(WWWGROUP) $(PREFIX)$(STATICFILESDIR)
	install $(addprefix -o ,$(WWWUSER)) $(addprefix -g ,$(WWWGROUP)) $< $(PREFIX)$(ELIOMSTATICDIR)
install.etc: $(CONFIG_FILE) $(SEXP_FILE) | $(PREFIX)$(ETCDIR)
	install -t $(PREFIX)$(ETCDIR) $^

.PHONY:
print-install-files:
	@echo $(PREFIX)$(LIBDIR)
	@echo $(PREFIX)$(STATICFILESDIR)
	@echo $(PREFIX)$(ELIOMSTATICDIR)
	@echo $(PREFIX)$(ETCDIR)

$(addprefix $(PREFIX),$(ETCDIR) $(LIBDIR)):
	install -d $@
$(addprefix $(PREFIX),$(DATADIR) $(LOGDIR) $(STATICFILESDIR) $(ELIOMSTATICDIR) $(shell dirname $(CMDPIPE))):
	install $(addprefix -o ,$(WWWUSER)) $(addprefix -g ,$(WWWGROUP)) -d $@

run.byte:
	$(OCSIGENSERVER) $(RUN_DEBUG) -c ${PREFIX}${ETCDIR}/${PROJECT_NAME}.conf
run.opt:
	$(OCSIGENSERVER.OPT) $(RUN_DEBUG) -c ${PREFIX}${ETCDIR}/${PROJECT_NAME}.conf

##----------------------------------------------------------------------
## Config files

FINDLIB_PACKAGES=$(patsubst %,\<extension\ findlib-package=\"%\"\ /\>,$(SERVER_PACKAGES))
EDIT_WARNING=DON\'T EDIT THIS FILE! It is generated from $(CONF_IN), edit that one, or the variables in Makefile.options
SED_ARGS = -e "/^ *%%%/d"
SED_ARGS += -e "s|%%PROJECT_NAME%%|$(PROJECT_NAME)|g"
SED_ARGS += -e "s|%%CMDPIPE%%|%%PREFIX%%$(CMDPIPE)|g"
SED_ARGS += -e "s|%%MANAGE_PROJECT_NAME%%|$(MANAGE_PROJECT_NAME)|g"
SED_ARGS += -e "s|%%MANAGECMDPIPE%%|%%PREFIX%%$(MANAGECMDPIPE)|g"
SED_ARGS += -e "s|%%LOGDIR%%|%%PREFIX%%$(LOGDIR)|g"
SED_ARGS += -e "s|%%DATADIR%%|%%PREFIX%%$(DATADIR)|g"
SED_ARGS += -e "s|%%LIBDIR%%|%%PREFIX%%$(LIBDIR)|g"
SED_ARGS += -e "s|%%WARNING%%|$(EDIT_WARNING)|g"
SED_ARGS += -e "s|%%PACKAGES%%|$(FINDLIB_PACKAGES)|g"
SED_ARGS += -e "s|%%ELIOMSTATICDIR%%|%%PREFIX%%$(ELIOMSTATICDIR)|g"
SED_ARGS += -e "s|%%DEFAULT_HOSTNAME%%|$(HOSTNAME)|g"
SED_ARGS += -e "s|%%DEFAULT_HTTP_PORT%%|$(DEFAULT_HTTP_PORT)|g"
SED_ARGS += -e "s|%%DEFAULT_HTTPS_PORT%%|$(DEFAULT_HTTPS_PORT)|g"
SED_ARGS += -e "s|%%DEFAULT_PROTOCOL%%|$(DEFAULT_PROTOCOL)|g"

ifeq ($(DEBUG),yes)
  SED_ARGS += -e "s|%%DEBUGMODE%%|\<debugmode /\>|g"
else
  SED_ARGS += -e "s|%%DEBUGMODE%%||g"
endif

LOCAL_SED_ARGS := -e "s|%%PORT%%|$(TEST_PORT)|g"
LOCAL_SED_ARGS += -e "s|%%STATICFILESDIR%%|$(LOCAL_STATIC)|g"
GLOBAL_SED_ARGS := -e "s|%%PORT%%|$(PORT)|g"
GLOBAL_SED_ARGS += -e "s|%%STATICFILESDIR%%|%%PREFIX%%$(STATICFILESDIR)|g"

$(CONFIG_FILE): $(CONF_IN) Makefile.options | $(TEST_PREFIX)$(ETCDIR)
	sed $(SED_ARGS) $(GLOBAL_SED_ARGS) $< | sed -e "s|%%PREFIX%%|$(PREFIX)|g" > $@

$(TEST_CONFIG_FILE): $(CONF_IN) Makefile.options | $(TEST_PREFIX)$(ETCDIR)
	sed $(SED_ARGS) $(LOCAL_SED_ARGS) $< | sed -e "s|%%PREFIX%%|$(TEST_PREFIX)|g" > $@

$(SEXP_FILE): $(SEXP_IN) | $(TEST_PREFIX)$(ETCDIR)
	install $< $@

##----------------------------------------------------------------------
## Compilation

include Makefile.compile

##----------------------------------------------------------------------
## Management mock project specific compilation

include Makefile.manage

##----------------------------------------------------------------------
## Clean up

.PHONY: clean

clean:
	-rm -f *.cm[ioax] *.cmxa *.cmxs *.o *.a *.annot
	-rm -f *.type_mli
	-rm -f ${PROJECT_NAME}.js
	-rm -rf ${ELIOM_CLIENT_DIR} ${ELIOM_SERVER_DIR}

distclean: clean
	-rm -rf $(TEST_PREFIX) $(DEPSDIR) .depend

##----------------------------------------------------------------------
## Format

fmt:
	$(OCAMLFORMAT) --inplace $(SERVER_FILES) $(CLIENT_FILES) $(MANAGE_FILES)
