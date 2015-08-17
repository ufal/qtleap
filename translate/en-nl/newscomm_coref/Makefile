include ../../makefile.master
include ../makefile.langpair
JOBS=100
DATASET=newscomm_coref
INPUT_SRC=$(IN_DIR)/all.en.src.txt
INPUT_REF=$(IN_DIR)/all.cs.ref.txt

# as a first step, data was copied to $(IN_DIR)
# from /net/cluster/TMP/mnovak/data/News-Commentaries_nl-en/*_test_*.txt

prepare_data : $(INPUT_SRC) $(INPUT_REF)

$(INPUT_SRC) :
	cat $(IN_DIR)/src_* > $@
$(INPUT_REF) :
	cat $(IN_DIR)/ref_* > $@
