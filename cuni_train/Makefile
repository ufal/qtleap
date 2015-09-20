SHELL=bash

define HELP_MESSAGE
# USAGE:

make qtleap-corpus
(cd ../qtleap-corpus/ && git pull)
# First, make sure you have the newest version of the QTLeap Corpus.

# The only parameter that must be specified in all the following commands is the translation pair, 
# e.g. for translation from English to Czech
# <TRANSL_PAIR=en_cs>
# All the other parameters can be specified in the corresponding configuration file, e.g.
# <conf/en_cs.conf>
# However, specifying them directly as command line arguments is still possible. 
# Moreover, you can redefine the config file used as a default:
# <CONFIG_FILE=my_new_config.conf>
# Note that parallel data are the same regardless the translation direction. Therefore, the parameters
# common to both directions should be specified in <conf/lang_en.conf>, where lang has to be replaced
# by the particular language. Before the config file for a given translation pair is loaded, 
# the script also loads <conf/lang_en.conf>. For instance, if one sets <TRANSL_PAIR=en_cs>, <conf/cs_en.conf>
# and then <conf/en_cs.conf> are loaded. However, if <TRANSL_PAIR=cs_en>, only <conf/cs_en.conf> is loaded.

make transl_models TRANSL_PAIR=cs_en
# To analyze parallel training data and create t-lemma and formeme translation models.
# These models will be used for translation.

endef
export HELP_MESSAGE

help:
	@COLORED_HELP_MESSAGE=$$(echo "$$HELP_MESSAGE" | sed 's/<\([^>]*\)>/\\\e[01;33m\1\\\e[0m/g' | sed 's/^\(make .*\)/\\\e[01;31m\1\\\e[0m/'); \
	echo -e "$$COLORED_HELP_MESSAGE"

TRANSL_PAIR:=cs_en
SRC_LANG:=$(shell echo $(TRANSL_PAIR) | cut -f1 -d'_')
TRG_LANG:=$(shell echo $(TRANSL_PAIR) | cut -f2 -d'_')
PARA_DATA_PAIR := $(shell perl -e 'my ($$l1, $$l2) = split /_/, "$(TRANSL_PAIR)"; if ($$l1 eq "en") {print $$l2."_".$$l1;} else {print $$l1."_".$$l2;};')

CONFIG_FILE?=$(realpath $(shell perl -e 'use List::MoreUtils qw/uniq/; my @l = uniq @ARGV; print join " ", @l; print "\n";' conf/$(PARA_DATA_PAIR).conf conf/$(TRANSL_PAIR).conf))
include $(CONFIG_FILE)

include makefile.cluster_conf
export LRC

#######################
#### TRANSL MODELS ####
#######################

TRAIN_DATA_STEM=$(shell bin/para_data_stem.pl "$(TRAIN_DATA)")
TRAIN_TMP_DIR=tmp/$(TRANSL_PAIR)/$(TRAIN_DATA_STEM)

TM_TLEMMA_DIR=$(TRAIN_TMP_DIR)/tm_tlemma
TM_FORMEME_DIR=$(TRAIN_TMP_DIR)/tm_formeme

TLEMMA_STATIC_TM?=$(TM_TLEMMA_DIR)/model.static.gz
TLEMMA_MAXENT_TM?=$(TM_TLEMMA_DIR)/model.maxent.gz
FORMEME_STATIC_TM?=$(TM_FORMEME_DIR)/model.static.gz
FORMEME_MAXENT_TM?=$(TM_FORMEME_DIR)/model.maxent.gz

TLEMMA_TMS ?=static 0.5 $(TLEMMA_STATIC_TM)  maxent 1.0 $(TLEMMA_MAXENT_TM)
FORMEME_TMS?=static 1.0 $(FORMEME_STATIC_TM) maxent 0.5 $(FORMEME_MAXENT_TM)

TMT_RESOURCE_PATHS := $(shell perl -e 'use Treex::Core::Config; my @a = Treex::Core::Config->resource_path(); print join " ", @a; print "\n";')
full_resource_path=$(word 1,$(realpath $(foreach dir,$(TMT_RESOURCE_PATHS),$(dir)/$1)))

TLEMMA_STATIC_TM_FULLPATH =$(or $(call full_resource_path,$(TLEMMA_STATIC_TM)),$(TM_TLEMMA_DIR)/model.static.gz)
TLEMMA_MAXENT_TM_FULLPATH =$(or $(call full_resource_path,$(TLEMMA_MAXENT_TM)),$(TM_TLEMMA_DIR)/model.maxent.gz)
FORMEME_STATIC_TM_FULLPATH=$(or $(call full_resource_path,$(FORMEME_STATIC_TM)),$(TM_FORMEME_DIR)/model.static.gz)
FORMEME_MAXENT_TM_FULLPATH=$(or $(call full_resource_path,$(FORMEME_MAXENT_TM)),$(TM_FORMEME_DIR)/model.maxent.gz)

TRANSL_MODELS=$(TLEMMA_STATIC_TM_FULLPATH) $(TLEMMA_MAXENT_TM_FULLPATH) $(FORMEME_STATIC_TM_FULLPATH) $(FORMEME_MAXENT_TM_FULLPATH)

PARA_DATA_SRC_SEL?=src

export ML_CONFIG_FILE

transl_models : $(TRANSL_MODELS)
$(TRANSL_MODELS) :
	$(MAKE) -f makefile.tm $@ TRANSL_PAIR=$(TRANSL_PAIR) DATA="$(TRAIN_DATA)" STAGE=$(TRAIN_DATA_STAGE) PARA_DATA_SRC_SEL=$(PARA_DATA_SRC_SEL) LRC=$(LRC)

clean_tm clean_tm_train_table clean_analysis clean_for_giza clean_giza clean_tecto :
	$(MAKE) -f makefile.tm $@ TRANSL_PAIR=$(TRANSL_PAIR) DATA="$(TRAIN_DATA)" STAGE=$(TRAIN_DATA_STAGE) LRC=$(LRC)

qtleap-corpus: ../qtleap-corpus
../qtleap-corpus:
	git clone gitolite@redmine.ms.mff.cuni.cz:qtleap/qtleap-corpus.git $@
