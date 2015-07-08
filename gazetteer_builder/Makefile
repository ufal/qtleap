SHELL=/bin/bash
download : url.list
	cat $< | cut -f2 | xargs wget

unpack :
	tar -xvvJf 

extract_phrases :
	./extract_phrases.pl en.gaz cs.gaz
	cat vlc-2.1.5/po/cs.po | ./extract_phrases.pl en.vlc.gaz cs.vlc.gaz vlc_
	 find libreoffice-4.4.0.3/translations/source/cs -name '*.po' -exec cat {} \; | ./extract_phrases.pl en.libreoffice.gaz cs.libreoffice.gaz libreoffice_

export :
	mkdir ${TMT_ROOT}/share/data/models/gazeteer
	cat en.libreoffice.gaz en.vlc.gaz | gzip -c > /home/mnovak/projects/tectomt//share/data/models/gazeteer/en.app_labels.gaz.gz
	cat cs.libreoffice.gaz cs.vlc.gaz | gzip -c > /home/mnovak/projects/tectomt//share/data/models/gazeteer/cs.app_labels.gaz.gz


LANGUAGE=cs

BUILD_DIR=build/$(LANGUAGE)
EXTRACT_SCRIPTS_DIR=extract_scripts/$(LANGUAGE)

SOURCE_NAMES=$(shell for i in $(EXTRACT_SCRIPTS_DIR)/*; do prefix=$${i%.sh}; echo $${prefix\#\#*/}; done)
EN_GAZ_LIST=$(shell for i in $(SOURCE_NAMES); do echo "$(BUILD_DIR)/$(LANGUAGE)_en.en.$$i.gaz"; done)
OTHERLANG_GAZ_LIST=$(shell for i in $(SOURCE_NAMES); do echo "$(BUILD_DIR)/$(LANGUAGE)_en.$(LANGUAGE).$$i.gaz"; done)

source_names :
	echo $(SOURCE_NAMES)
	echo $(EN_GAZ_LIST)
	echo $(OTHERLANG_GAZ_LIST)



$(BUILD_DIR)/$(LANGUAGE)_en.$(LANGUAGE).all.gaz.gz : 
$(BUILD_DIR)/$(LANGUAGE)_en.en.all.gaz.gz : $(BUILD_DIR)/$(LANGUAGE)_en.$(LANGUAGE).all.gaz.gz
