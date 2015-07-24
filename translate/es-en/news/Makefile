include ../../makefile.master
include ../makefile.langpair
DATASET=news

# ../makefile.langpair contains domain=IT, but we want to override it
SCENARIO=Scen::ES2EN domain=general resegment=1

# news_en.txt is a concatenation of news2012_en.txt (604 lines) and news2013_en.txt (500 lines)
# so we have 1104 segments (some of which contain more than one linguistic sentence) and more reliable results.
INPUT_SRC=../../../qtleap-corpus/references/news_es.txt
INPUT_REF=../../../qtleap-corpus/references/news_en.txt

$(IN_DIR): $(INPUT_SRC) $(INPUT_REF)
$(INPUT_SRC): ../../../qtleap-corpus/references/news2012_es.txt ../../../qtleap-corpus/references/news2013_es.txt 
	cat $^ > $@

$(INPUT_REF): ../../../qtleap-corpus/references/news2012_en.txt ../../../qtleap-corpus/references/news2013_en.txt 
	cat $^ > $@
