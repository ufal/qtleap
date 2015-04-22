
SHELL := bash
INPUT_DIR  := input
RUNS_DIR   := runs
SCENARIO   := ../nl_analysis_w2p.scen ../nl_analysis_p2t.scen
TRY_NUM    := $(shell perl -e '$$m=0; for(<$(RUNS_DIR)/*>){/\/(\d+)_/ and $$1 > $$m and $$m=$$1;} printf "%03d", $$m+1;')
DATE       := $(shell date +%Y-%m-%d_%H-%M-%S)
TRY_DIR    = $(RUNS_DIR)/$(TRY_NUM)_$(DATE)# experiment output directory
PARALLEL_RUN_NAME = treex-run

ifdef D # Shortcut D -> DESC
      DESC := $(D)
endif

# Scenario shortcuts
ifeq ($(S),w2t)
  SCENARIO   := ../nl_analysis_w2p.scen ../nl_analysis_p2t.scen
endif
ifeq ($(S),w2t2w)
  SCENARIO   := ../nl_analysis_w2p.scen ../nl_analysis_p2t.scen ../nl_synthesis_t2w.scen
endif

all:
	echo 'Read the makefile!'

desc:
	@ls $(RUNS_DIR)/*/ABOUT | sort | while read file; do echo -ne $$file ": \t"; cat $$file; done

prepare_dir:
	# create the directory (and parallel run directory if needed)
	mkdir -p $(TRY_DIR)/$(PARALLEL_RUN_NAME)
	# write the description
	@if [ -n "$(DESC)" ]; then \
		echo "$(DESC)" > $(TRY_DIR)/ABOUT; \
	fi

run: prepare_dir
	treex -p -j 10 --workdir=$(TRY_DIR)/$(PARALLEL_RUN_NAME) -Lnl \
	    Read::Sentences from='!$(INPUT_DIR)/*.txt' $(SCENARIO) \
	    Write::CoNLLX path=$(TRY_DIR) \
	    Write::Treex path=$(TRY_DIR) \
	    Write::AttributeSentences layer=a attributes='form ord parent->ord' path=$(TRY_DIR)

compare-%:
	NUM1=`echo $* | cut -d: -f1`; NUM2=`echo $* | cut -d: -f2`; \
	DIR1=`echo $(RUNS_DIR)/$$NUM1*/`; DIR2=`echo $(RUNS_DIR)/$$NUM2*/` ; \
	cat $$DIR1/alp*.txt > $$DIR1/all.txt ; \
	cat $$DIR2/alp*.txt > $$DIR2/all.txt ; \
	vimdiff $$DIR1/all.txt $$DIR2/all.txt

