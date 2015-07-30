SHELL=bash

define HELP_MESSAGE
# USAGE:
#
# This is a makefile to build gazetteers used in TectoMT translation for IT domain.
# A gazetteer consists of two lists: the list of phrases in the language specified
# by the parameter <LANGUAGE> and the list of English phrases. Every line in the list
# corresponds to one phrase and its identifier. English and the other-language list are
# paired in the way that every phrase in the other-language list is a translation
# of the English phrase on the corresponding line. 
# The gazetteer is in fact a concatenation of (pairs of) lists extracted from different 
# sources. For each source, an extractor script must be provided and stored 
# in <extract_scripts/$$LANGUAGE>. The name of the extractor script (skipping the extension <.sh>) 
# is used as an identifier of the particular source in the final gazetteer.

make build LANGUAGE=cs
make build LANGUAGE=cs SOURCE_NAMES="vlc kde"
# Build Czech-English gazetteer and store it in <build/cs>. Extraction is run for every
# source specified by its extractor script in <extract_scripts/cs>. A subset of sources to be processed
# can be specified by the parameter <SOURCE_NAMES>.
endef
export HELP_MESSAGE

help:
	@COLORED_HELP_MESSAGE=$$(echo "$$HELP_MESSAGE" | sed 's/<\([^>]*\)>/\\\e[01;33m\1\\\e[0m/g' | sed 's/^\(make .*\)/\\\e[01;31m\1\\\e[0m/'); \
	echo -e "$$COLORED_HELP_MESSAGE"

LANGUAGE=cs

BUILD_DIR=build/$(LANGUAGE)
TMP_DIR=tmp/$(LANGUAGE)
EXTRACT_SCRIPTS_DIR=extract_scripts/$(LANGUAGE)

SOURCE_NAMES=$(shell for i in $(EXTRACT_SCRIPTS_DIR)/*; do prefix=$${i%.sh}; echo $${prefix\#\#*/}; done)
#SOURCE_NAMES=libreoffice vlc kde
EN_GAZ_LIST=$(shell for i in $(SOURCE_NAMES); do echo "$(BUILD_DIR)/$(LANGUAGE)_en.en.$$i.gaz"; done)
OTHERLANG_GAZ_LIST=$(shell for i in $(SOURCE_NAMES); do echo "$(BUILD_DIR)/$(LANGUAGE)_en.$(LANGUAGE).$$i.gaz"; done)

$(BUILD_DIR) :
	mkdir -p $(BUILD_DIR)
$(TMP_DIR) :
	mkdir -p $(TMP_DIR)

$(BUILD_DIR)/$(LANGUAGE)_en.$(LANGUAGE).%.gaz : $(EXTRACT_SCRIPTS_DIR)/%.sh | $(BUILD_DIR) $(TMP_DIR)
	$< $(BUILD_DIR)/$(LANGUAGE)_en.en.$*.gaz $@ $*_ $(TMP_DIR)

$(BUILD_DIR)/$(LANGUAGE)_en.$(LANGUAGE).all.gaz.gz : $(OTHERLANG_GAZ_LIST)
	cat $^ | gzip -c > $@
$(BUILD_DIR)/$(LANGUAGE)_en.en.all.gaz.gz : $(EN_GAZ_LIST)
	cat $^ | gzip -c > $@

build : $(BUILD_DIR)/$(LANGUAGE)_en.$(LANGUAGE).all.gaz.gz $(BUILD_DIR)/$(LANGUAGE)_en.en.all.gaz.gz
