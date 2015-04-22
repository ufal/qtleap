SHELL=bash

define HELP_MESSAGE
# USAGE:
#
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

make prepare_test_data TRANSL_PAIR=cs_en
# Prepare the test data, i.e. split plain text to several documents and create SGM files,
# which are needed for MT evaluation.
# The data can be specified by assigning paths to the <TEST_DATA> variable in the following format:
# <TEST_DATA="path_to_data/czech.data.sgm; path_to_data/english.data.sgm">
# The English part of the parallel data must be always specified as the second.
# Two formats of the test data are supported: plain text and SGM. The format can be specified
# assigning the variable <TEST_DATA_STAGE> the value <orig_plain> (default) or <segm>, respectively.
# To facilitate the test dataset setting, one can store a list of the frequently used datasets 
# with their labels to the <TEST_DATASET_HASH> variable in the config file (see e.g. <conf/cs_en.conf>).
# If any dataset is in SGM format, its label has to be contained in a space-separated list 
# assigned to <TEST_DATASET_IN_SGM> variable.
# Then, a particular dataset is selected by setting the <TEST_DATASET> variable to the dataset's label.

make translate eval TRANSL_PAIR=cs_en
make translate eval TRANSL_PAIR=cs_en TEST_DATASET=newstest2012
# It translates and evaluates the specified test data.
# If the translation models are not present, it tries to train them.
# If you want to use already trained models, copy them into share and specify the paths 
# in the config file (e.g. see <conf/en_cs.conf> for English to Czech translation models)

make translate eval S=scenarios/02_my_alternative.scen
# TODO S is not yet supported
# Now try an alternative scenario
# All the experiments are saved in $(RUNS_DIR) in a subdirectory with current date in name.

make translate eval TRANSL_PAIR=cs_en D="changed regexp in block XY"
# You can add a short description of the experiment to be logged

make compare
# Useful comparison of outputs of the two scenarios is saved in compared_with_* files. 
# With this command you can see the same info which compares the baseline with the last experiment.

make baseline
# Write this to set the last experiment as the baseline (after you have checked it is better than the previous one).
# It will print the name of the last experiment directory to $(RUNS_DIR)/baseline.

make baseline-042
# If you want to comfortably set another experiment as the baseline, look up its prefix number and call, e.g. this,
# which will set $(RUNS_DIR)/042_2010-01-14_14-07-02_my_scenario (let's say) as the baseline.

make compare-042:046
# Compare experiments with numbers 042 and 046 (without changing $(RUNS_DIR)/baseline).

make eval-046
# Evaluate experiment number 046 (if you have forgotten to add eval after translate).

make pilot0 eval-000
# Copy Pilot 0 (moses) output to $(RUNS_DIR)/000_pilot0, compute its BLEU

# If you don't want to print commands being executed, use "make -s".
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


##################### translation ##########################
include makefile.test_data
include makefile.translation
