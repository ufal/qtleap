SHELL=bash

#IN=automatic_sample.txt
#IN=sample.txt
IN=sample_parsed.treex.gz

#READER=Read::Sentences from=$(IN)
READER=Read::Treex from=sample_parsed.treex.gz

NO_WORDFORMS=0

# For "roundtrip", i.e. analysis+synthesis+eval use
SCENARIO=word2tecto.scen t2a.scen

LEMMA_SENT = Util::Eval zone='$$.set_sentence(join " ", map {$$_->lemma} $$.get_atree->get_descendants({ordered=>1}))'

all: go bleu diff

BASE:=$(shell IN=$(IN) && echo $${IN%%.*})

# I prepared English translations for my better orientation, so let's load it.
SOURCE_LANG:=es
ifeq ($(IN),sample.txt)
  SCENARIO:=Util::Eval doc='use File::Slurp; $$self->{trans}=[read_file("sample.translated.txt", chomp=>1, binmode => ":utf8")]' bundle='$$.create_zone("en")->set_sentence(shift @{$$self->{trans}});' $(SCENARIO)
  SOURCE_LANG:=en
endif
ifeq ($(IN),automatic_sample.txt)
  SCENARIO:=Util::Eval doc='use File::Slurp; $$self->{trans}=[read_file("automatic_sample.translated.txt", chomp=>1, binmode => ":utf8")]' bundle='$$.create_zone("en")->set_sentence(shift @{$$self->{trans}});' $(SCENARIO)
  SOURCE_LANG:=en
endif


RESUME=Print::TranslationResume source_language=$(SOURCE_LANG) source_selector= reference_selector= extension=treex.gz
WRITER=Write::Treex $(RESUME) selector=synthesis



ifeq ($(NO_WORDFORMS),1)
SCENARIO:= $(SCENARIO) $(LEMMA_SENT) selector=,synthesis
diff: $(BASE)_ideal_lemmatized.txt
	./compare_stats.pl $(BASE)_ideal_lemmatized.txt $(BASE)_output.txt | less -R
else
SCENARIO:= $(SCENARIO) a2w.scen
diff: $(BASE)_ideal.txt
	./compare_stats.pl $(BASE)_ideal.txt $(BASE)_output.txt | less -R
endif



go:
	[ -f $(BASE)_output.txt ] && mv $(BASE)_output.txt $(BASE)_last_output.txt || exit 0
	treex -Les $(READER) $(SCENARIO) $(WRITER) > $(BASE)_output.txt

bleu:
	./compute_bleu.pl < $(BASE)_output.txt

$(BASE)_ideal.txt:
	treex -Les $(RESUME) selector= -- $(BASE).treex.gz > $@

$(BASE)_ideal_lemmatized.txt:
	treex -Les $(LEMMA_SENT) $(RESUME) selector= -- $(BASE).treex.gz > $@


lastdiff:
	./compare_stats.pl $(BASE)_last_output.txt $(BASE)_output.txt | less -R

clean:
	rm *{.treex.gz,_output.txt,_ideal.txt,_ideal_lemmatized.txt}