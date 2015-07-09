SHELL=/bin/bash

LANGUAGE=cs

BUILD_DIR=build/$(LANGUAGE)
EXTRACT_SCRIPTS_DIR=extract_scripts/$(LANGUAGE)

#SOURCE_NAMES=$(shell for i in $(EXTRACT_SCRIPTS_DIR)/*; do prefix=$${i%.sh}; echo $${prefix\#\#*/}; done)
SOURCE_NAMES=libreoffice vlc
EN_GAZ_LIST=$(shell for i in $(SOURCE_NAMES); do echo "$(BUILD_DIR)/$(LANGUAGE)_en.en.$$i.gaz"; done)
OTHERLANG_GAZ_LIST=$(shell for i in $(SOURCE_NAMES); do echo "$(BUILD_DIR)/$(LANGUAGE)_en.$(LANGUAGE).$$i.gaz"; done)

$(BUILD_DIR) :
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/$(LANGUAGE)_en.$(LANGUAGE).%.gaz : $(EXTRACT_SCRIPTS_DIR)/%.sh | $(BUILD_DIR)
	$< $(BUILD_DIR)/$(LANGUAGE)_en.en.$*.gaz $@ $*_ $(CLEAN_FLAG)

$(BUILD_DIR)/$(LANGUAGE)_en.$(LANGUAGE).all.gaz.gz : $(OTHERLANG_GAZ_LIST)
	cat $^ | gzip -c > $@
$(BUILD_DIR)/$(LANGUAGE)_en.en.all.gaz.gz : $(EN_GAZ_LIST)
	cat $^ | gzip -c > $@

build : $(BUILD_DIR)/$(LANGUAGE)_en.$(LANGUAGE).all.gaz.gz $(BUILD_DIR)/$(LANGUAGE)_en.en.all.gaz.gz
