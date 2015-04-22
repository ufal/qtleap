SHELL=bash

IN:=cintilUSD.conll
#IN:=cintil.conll
#IN=small.conll
# For larger versions of cintil.conll and small.conll, use
#IN=depbank-v3v4.conll.gz
#IN=sample_300-annotated.conll.gz

READER=Read::CoNLLX from=$(IN)
#READER=Read::CoNLLX from=$(IN) lines_per_doc=100

# For "roundtrip", i.e. analysis+synthesis+eval use
SCENARIO=conll2tecto.scen t2a.scen
# For analysisi only use:
#SCENARIO=conll2tecto.scen

# I used the first 100 sentences of CINTIL for debugging
# and I prepared English translations for my better orientation, so let's load it.
# Also, cintil.conll does not use "\*" and "*/" to mark spaces around punctuation.
SOURCE_LANG:=pt
ifeq ($(IN),cintil.conll)
 SCENARIO:=Util::SetGlobal punctuation_spaces_marked=0 $(SCENARIO)
 SCENARIO:=Util::Eval doc='use File::Slurp; $$self->{trans}=[read_file("translated.txt", chomp=>1)]' bundle='$$.create_zone("en")->set_sentence(shift @{$$self->{trans}});' $(SCENARIO)
 SOURCE_LANG:=en
endif

ifeq ($(IN),cintilUSD.conll)
 SCENARIO:=usd2tecto.scen t2a.scen
 SCENARIO:=Util::Eval doc='use File::Slurp; $$self->{trans}=[read_file("translated.txt", chomp=>1)]' bundle='$$.create_zone("en")->set_sentence(shift @{$$self->{trans}});' $(SCENARIO)
 SOURCE_LANG:=en
endif


#BASE:=$(basename $(IN)) #does not  work for double extension (.conll.gz)
BASE:=$(shell IN=$(IN) && echo $${IN%%.*})

RESUME=Print::TranslationResume source_language=$(SOURCE_LANG) source_selector= language=pt reference_selector= extension=treex.gz
WRITER=Write::Treex $(RESUME) selector=synthesis

go:
	treex -Lpt $(READER) $(SCENARIO) $(WRITER) > $(BASE)_output.txt

bleu:
	./compute_bleu.pl < $(BASE)_output.txt

$(BASE)_ideal.txt:
	treex $(RESUME) selector= -- $(BASE).treex.gz > $@

diff: $(BASE)_ideal.txt
	./compare_stats.pl $(BASE)_ideal.txt $(BASE)_output.txt | less -R

clean:
	rm *{.treex.gz,_output.txt,_ideal.txt}

# file sample_12566_usd.conll.gz has 1MiB which is too much to be stored in the svn
SHARE_PT=${TMT_ROOT}/share/data/resources/treebanks/pt/cintil/
URL_PT=http://ufallab.ms.mff.cuni.cz/~popel/
Cintil2USD.conll.gz batch2q_usd.conll.gz batch2a_usd.conll.gz:
	if [ -f $(SHARE_PT)/$@ ] ; then cp $(SHARE_PT)/$@ .; else wget $(URL_PT)/$@; fi
