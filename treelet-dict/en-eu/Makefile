SHELL=bash

BASE?=MicrosoftTermCollection
ANALYSIS_DIR=split/analysis

SRC_LANG=en
TRG_LANG=eu


SRC=@split/$(SRC_LANG)/filelist.txt
TRG=@split/$(TRG_LANG)/filelist.txt

SRC_SCENARIO=Util::SetGlobal selector=src language=$(SRC_LANG) Scen::Analysis::EN
TRG_SCENARIO=Util::SetGlobal selector=trg language=$(TRG_LANG) Scen::Analysis::EU


READER=Read::AlignedSentences $(SRC_LANG)_src=$(SRC) $(TRG_LANG)_trg=$(TRG)

all: extract analyze

SCENARIO:=$(SRC_SCENARIO) $(TRG_SCENARIO)


WRITER=Write::Treex storable=1 path=$(ANALYSIS_DIR)

extract:
	../bin/tbx2tsv.pl ./$(BASE).tbx en-US eu-es > $(BASE).$(SRC_LANG)-$(TRG_LANG).tsv
	mkdir -p split/$(SRC_LANG) split/$(TRG_LANG)
	cut -f 1 < $(BASE).$(SRC_LANG)-$(TRG_LANG).tsv > $(BASE).$(SRC_LANG).txt
	split -d -l 200 -a 5 $(BASE).$(SRC_LANG).txt split/$(SRC_LANG)/part_
	ls split/$(SRC_LANG)/part_* | sed -e "s|^split\/$(SRC_LANG)\/||" > split/$(SRC_LANG)/filelist.txt
	cut -f 2 < $(BASE).$(SRC_LANG)-$(TRG_LANG).tsv > $(BASE).$(TRG_LANG).txt
	split -d -l 200 -a 5 $(BASE).$(TRG_LANG).txt split/$(TRG_LANG)/part_
	ls split/$(TRG_LANG)/part_* | sed -e "s|^split\/$(TRG_LANG)\/||" > split/$(TRG_LANG)/filelist.txt

analyze:
	treex -L$(SRC_LANG) -Ssrc $(READER) $(SCENARIO) $(WRITER)
clean:
	rm *.streex
