SHELL=bash

#IN=small.conll
IN:=batch1a_bg.conll.gz

READER=Read::CoNLLX from=$(IN)

# For "roundtrip", i.e. analysis+synthesis+eval use
SCENARIO=conll2tecto.scen t2a.scen a2w.scen

# Load English translations for my better orientation
SOURCE_LANG:=bg
ifeq ($(IN),batch1a_bg.conll.gz)
 SCENARIO:=Util::Eval doc='use File::Slurp; $$self->{trans}=[read_file("batch1a_en.txt", chomp=>1)]' bundle='$$.create_zone("en")->set_sentence(shift @{$$self->{trans}});' $(SCENARIO)
 SOURCE_LANG:=en
endif


#BASE:=$(basename $(IN)) #does not  work for double extension (.conll.gz)
BASE:=$(shell IN=$(IN) && echo $${IN%%.*})

RESUME=Print::TranslationResume source_language=$(SOURCE_LANG) source_selector= language=bg reference_selector= extension=treex.gz
WRITER=Write::Treex $(RESUME) selector=synthesis

all: go bleu diff

go:
	treex -Lbg $(READER) $(SCENARIO) $(WRITER) > $(BASE)_output.txt

bleu:
	./compute_bleu.pl < $(BASE)_output.txt

$(BASE)_ideal.txt:
	treex $(RESUME) selector= -- $(BASE).treex.gz > $@

diff: $(BASE)_ideal.txt
	./compare_stats.pl $(BASE)_ideal.txt $(BASE)_output.txt | less -R

clean:
	rm *{.treex.gz,_output.txt,_ideal.txt}

