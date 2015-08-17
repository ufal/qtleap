include ../../makefile.master
include ../makefile.langpair
LINES_PER_FILE=???
JOBS=200
DATASET=newstest2012_coref
INPUT_SRC=$(IN_DIR)/all.en.src.txt
INPUT_REF=$(IN_DIR)/all.cs.ref.txt

# prepare_data must be run at the very beginning

INPUT_SRC_SGM=$(TMT_ROOT)/share/data/resources/wmt/2012/test/newstest2012-src.en.sgm
INPUT_REF_SGM=$(TMT_ROOT)/share/data/resources/wmt/2012/test/newstest2012-src.cs.sgm

prepare_data : split_data_by_doc $(INPUT_SRC) $(INPUT_REF)

split_data_by_doc :
	mkdir -p $(IN_DIR)
	./segm2docs.pl $(IN_DIR)/ref_ < $(INPUT_REF_SGM)
	./segm2docs.pl $(IN_DIR)/src_ < $(INPUT_SRC_SGM)

$(INPUT_SRC) :
	cat $(IN_DIR)/src_* > $@
$(INPUT_REF) :
	cat $(IN_DIR)/ref_* > $@
	
