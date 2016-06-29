SHELL=bash

BASE?=MicrosoftTermCollection

SRC_LANG=en
TRG_LANG=es


SRC=$(BASE).$(SRC_LANG).txt
TRG=$(BASE).$(TRG_LANG).txt

SRC_SCENARIO=Util::SetGlobal selector=src language=$(SRC_LANG) Scen::Analysis::EN
TRG_SCENARIO=Util::SetGlobal selector=trg language=$(TRG_LANG) Scen::Analysis::ES


READER=Read::AlignedSentences $(SRC_LANG)_src=$(SRC) $(TRG_LANG)_trg=$(TRG)

all: extract analyze

SCENARIO:=$(SRC_SCENARIO) $(TRG_SCENARIO)

WRITER=Write::Treex storable=1 to=$(BASE).streex

extract:
	../bin/tbx2tsv.pl ./$(BASE).tbx en-US es-es > $(BASE).$(SRC_LANG)-$(TRG_LANG).tsv
	cut -f 1 < $(BASE).$(SRC_LANG)-$(TRG_LANG).tsv > $(BASE).$(SRC_LANG).txt
	cut -f 2 < $(BASE).$(SRC_LANG)-$(TRG_LANG).tsv > $(BASE).$(TRG_LANG).txt

analyze: 
	treex -L$(SRC_LANG) -Ssrc $(READER) $(SCENARIO) $(WRITER)
clean:
	rm *.streex
