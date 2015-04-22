#
# NL analysis & synthesis using Alpino & Treex
# Run `make help' for available targets etc.
#

SHELL=bash

FILENAME=alpino-120
IN=$(FILENAME).txt
READER=Read::Sentences from=$(IN)

SCENARIO_W2P= nl_analysis_w2p.scen  Write::Treex to=$(FILENAME).ana-p.treex.gz
SCENARIO_P2T= nl_analysis_p2t.scen  Write::Treex to=$(FILENAME).ana-t.treex.gz
SCENARIO_T2P= nl_synthesis_t2p.scen Write::Treex to=$(FILENAME).syn-p.treex.gz Write::ADTXML to=$(FILENAME).adt.xml sent_ids=1
SCENARIO_P2W= nl_synthesis_p2w.scen Write::Treex to=$(FILENAME).syn-w.treex.gz
SCENARIO= $(SCENARIO_W2P) $(SCENARIO_P2T) $(SCENARIO_T2P) $(SCENARIO_P2W)


OUT=$(FILENAME).out.txt
RESUME=Print::TranslationResume source_language=nl source_selector= language=nl reference_selector= extension=treex.gz selector=synthesis
WRITER=Write::Sentences to=$(OUT) $(RESUME) > $(FILENAME).resume.txt


ifeq ($(PART),conv+syn)
  IN=$(FILENAME).ana-p.treex.gz
  READER=Read::Treex from=$(IN)
  SCENARIO= $(SCENARIO_P2T) $(SCENARIO_T2P) $(SCENARIO_P2W)
endif
ifeq ($(PART),syn)
  IN=$(FILENAME).ana-t.treex.gz
  READER=Read::Treex from=$(IN)
  SCENARIO= $(SCENARIO_T2P) $(SCENARIO_P2W)
endif
ifeq ($(PART),top-alpino)
  IN=$(FILENAME).xml
  READER=Read::Alpino from=$(IN)
  SCENARIO= $(SCENARIO_P2T) $(SCENARIO_T2P)
  WRITER=
endif
ifeq ($(PART),top)
  IN=$(FILENAME).ana-p.treex.gz
  READER=Read::Treex from=$(IN)
  SCENARIO= $(SCENARIO_P2T) $(SCENARIO_T2P)
  WRITER=
endif
ifeq ($(PART),parse)
  SCENARIO= $(SCENARIO_W2P)
  WRITER=
endif
ifeq ($(PART),t-parse)
  SCENARIO= $(SCENARIO_W2P) $(SCENARIO_P2T)
  WRITER=
endif


define HELP_MESSAGE
NL analysis & synthesis using Alpino & Treex
============================================

* Run the analysis and synthesis:
make go

* You can also select just a part of the process to speed things up:

  * Parse the plain text sentences using Alpino and save the result into
    an .ana-p.treex.gz file
make go PART=parse

  * Parse the plain text sentences up to t-layer and save them into
    an .ana-t.treex.gz file
make go PART=t-parse

  * Everything after the initial Alpino parse (reading from a previously
    created .ana-p.treex.gz file)
make go PART=conv+syn

  * Just the synthesis (reading from an .ana-t.treex.gz file that
    contains t-layer analysis)
make go PART=syn

  * Just the part after the Alpino parse and before Alpino generation
    (reading from an .ana-p.treex.gz file)
make go PART=top

  * Ditto, but reading from Alpino XML file
make go PART=top-alpino

* You can change the FILENAME parameter to a file of your liking
  (without the extension, which must be .txt for plain text sentences
  and .xml for Alpino parse trees)

* The results of the last experiment (ADT XML + output text) are
  saved in *.adt.xml.last and *.out.txt.last, so you can compare them
  to the new outputs.

TODO BLEU measuring and TranslationResume do not work, yet.
endef
export HELP_MESSAGE

#
# Targets
#

help:
	@echo "$$HELP_MESSAGE" | egrep --color '^(\s*make.*|)'


go:
	for FILE in $(FILENAME).{out.txt,adt.xml}; do \
	    if [ -e $$FILE ]; then cp $$FILE $$FILE.last; fi; \
	done; \
	treex -Lnl $(READER) $(SCENARIO) $(WRITER)

bleu:
	./compute_bleu.pl < $(FILENAME).resume.txt
