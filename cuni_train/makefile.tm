SHELL=/bin/bash

# PARAMS TO BE SET:
# TRANSL_PAIR: translation pair in the "srclang_trglang" format, e.g. "en_cs" for making TMs for English to Czech translation
# DATA: a path to the parallel training data
# STAGE: a stage, to which the input training data is preprocessed (segm, orig_plain, tecto)
# OPTIONAL PARAMS:
# PARA_DATA_SRC_SEL: the name of the source language selector, if the data is specified in stage "tecto" (e.g. CzEng files have an empty selector "")
# TMP_DIR: run directory

include makefile.cluster_conf

TRG_LANG:=$(shell echo $(TRANSL_PAIR) | cut -f2 -d'_')
PARA_DATA_PAIR:=$(shell perl -e 'my ($$l1, $$l2) = split /_/, "$(TRANSL_PAIR)"; if ($$l1 eq "en") {print $$l2."_".$$l1;} else {print $$l1."_".$$l2;};')
PARA_DATA_SRC_LANG:=$(shell echo $(PARA_DATA_PAIR) | cut -f1 -d'_')
PARA_DATA_SRC_SEL=src

PARA_DATA_STEM:=$(shell bin/para_data_stem.pl "$(DATA)")

TMP_DIR=tmp/$(TRANSL_PAIR)/$(PARA_DATA_STEM)

######################################## analysis of parallel data ##################################################

PARA_DATA_ANALYSIS_PARAMS=DATA="$(DATA)" STAGE=$(STAGE) LANG_PAIR=$(PARA_DATA_PAIR) TMP_DIR=tmp/$(PARA_DATA_PAIR)/$(PARA_DATA_STEM)
TECTO_DATA_LIST:=$(shell $(MAKE) -s --no-print-directory -f makefile.para_data_analysis tecto_data_list $(PARA_DATA_ANALYSIS_PARAMS))

analysis : $(TECTO_DATA_LIST)
$(TECTO_DATA_LIST) :
	$(MAKE) -f makefile.para_data_analysis tecto $(PARA_DATA_ANALYSIS_PARAMS) LRC=$(LRC) JOBS=$(JOBS)

clean_analysis clean_for_giza clean_giza clean_parse clean_tecto : clean_tm_train_table
	$(MAKE) -f makefile.para_data_analysis $@ $(PARA_DATA_ANALYSIS_PARAMS)

######################################### extracting training tables for translation models  ############################################

TM_DATA_DIR=$(TMP_DIR)/tm_train_table
TM_DATA=$(TMP_DIR)/tm_train_table.gz
TREEX_LOG_DIR=log/treex
TREEX_LOG_DIR_PATTERN=$(TREEX_LOG_DIR)/{NNN}-extract-table-run-{XXXXX}

extract_table : $(TM_DATA)
$(TM_DATA) : $(TECTO_DATA_LIST)
	mkdir -p $(TM_DATA_DIR)
	mkdir -p $(TREEX_LOG_DIR)
	$(TREEX_BIN) --workdir="$(TREEX_LOG_DIR_PATTERN)" -L$(PARA_DATA_SRC_LANG) \
		Read::Treex from=@$< \
		Print::VectorsForTM selector=$(PARA_DATA_SRC_SEL) trg_lang=$(TRG_LANG) compress=1 to='.' substitute='{^.*/([^\/]*).gz$$}{$(TM_DATA_DIR)/$$1.txt.gz}'
	find $(TM_DATA_DIR) -name "*.txt.gz" | sort | xargs zcat | gzip -c > $@

clean_tm_train_table : clean_tm
	-rm -rf $(TM_DATA_DIR)
	-rm $(TM_DATA)

######################################## training translation models  ############################################

ifdef ML_CONFIG_FILE
ML_CONFIG_FILE_FLAG=CONFIG_FILE=$(ML_CONFIG_FILE)
endif

TM_TLEMMA_DIR=$(TMP_DIR)/tm_tlemma
TM_FORMEME_DIR=$(TMP_DIR)/tm_formeme
TM_TLEMMA_DATA=$(TM_TLEMMA_DIR)/tm_train_table.gz
TM_FORMEME_DATA=$(TM_FORMEME_DIR)/tm_train_table.gz

TLEMMA_STATIC_TM=$(TM_TLEMMA_DIR)/model.static.gz
TLEMMA_MAXENT_TM=$(TM_TLEMMA_DIR)/model.maxent.gz
FORMEME_STATIC_TM=$(TM_FORMEME_DIR)/model.static.gz
FORMEME_MAXENT_TM=$(TM_FORMEME_DIR)/model.maxent.gz

tlemma_static_tm_path : PATH=$(TLEMMA_STATIC_TM)
tlemma_maxent_tm_path : PATH=$(TLEMMA_MAXENT_TM)
formeme_static_tm_path : PATH=$(FORMEME_STATIC_TM)
formeme_maxent_tm_path : PATH=$(FORMEME_MAXENT_TM)
tlemma_static_tm_path tlemma_maxent_tm_path formeme_static_tm_path formeme_maxent_tm_path :
	@echo $(PATH)

train_tm : $(TLEMMA_STATIC_TM) $(TLEMMA_MAXENT_TM) $(FORMEME_STATIC_TM) $(FORMEME_MAXENT_TM)

$(TLEMMA_STATIC_TM) : $(TM_TLEMMA_DATA)
$(TLEMMA_STATIC_TM) : ML_METHOD=static
$(TLEMMA_STATIC_TM) : MODEL_DIR=$(TM_TLEMMA_DIR)

$(TLEMMA_MAXENT_TM) : $(TM_TLEMMA_DATA)
$(TLEMMA_MAXENT_TM) : ML_METHOD=maxent
$(TLEMMA_MAXENT_TM) : MODEL_DIR=$(TM_TLEMMA_DIR)

$(FORMEME_STATIC_TM) : $(TM_FORMEME_DATA)
$(FORMEME_STATIC_TM) : ML_METHOD=static
$(FORMEME_STATIC_TM) : MODEL_DIR=$(TM_FORMEME_DIR)

$(FORMEME_MAXENT_TM) : $(TM_FORMEME_DATA)
$(FORMEME_MAXENT_TM) : ML_METHOD=maxent
$(FORMEME_MAXENT_TM) : MODEL_DIR=$(TM_FORMEME_DIR)

$(TLEMMA_STATIC_TM) $(TLEMMA_MAXENT_TM) $(FORMEME_STATIC_TM) $(FORMEME_MAXENT_TM) :
	$(MAKE) -f makefile.train_tm train_tm DATA=$< ML_METHOD=$(ML_METHOD) $(ML_CONFIG_FILE_FLAG) TMP_DIR=$(MODEL_DIR) LRC=$(LRC)

$(TM_TLEMMA_DATA) : COLS=1,2,5
$(TM_FORMEME_DATA) : COLS=3,4,5
$(TM_TLEMMA_DATA) $(TM_FORMEME_DATA) : $(TM_DATA)
	mkdir -p $(dir $@)
	zcat $< | cut -f$(COLS) | gzip -c > $@

clean_tm :
	-rm -rf $(TM_TLEMMA_DIR)
	-rm -rf $(TM_FORMEME_DIR)

clean : clean_analysis clean_tm_train_table clean_tm
