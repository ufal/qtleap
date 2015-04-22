#!/bin/bash

source common.sh

function test_para_data_analysis_1 {
    printinfo "Testing para_data_analysis up to the tecto stage on cs-en orig_plain docs"
	make -f makefile.para_data_analysis tecto DATA="test/data/sample.cs-en.cs.txt; test/data/sample.cs-en.en.txt" STAGE=orig_plain LANG_PAIR=cs_en TMP_DIR=tmp/cs_en/sample.cs-en LRC=0
    orig_plain_lines=`cat test/data/sample.cs-en.cs.txt | wc -l`
    exists "tmp/cs_en/sample.cs-en"
	pushd tmp/cs_en/sample.cs-en
    split_plain_lines=`cat data_splits/*/part_*.txt | wc -l`
    eq $(($orig_plain_lines * 2)) $split_plain_lines "The accumulated number of lines in data_splits" 
    morpho_sents=`treex Read::Treex from=@trees.morpho/list Util::Eval bundle='print "BUNDLE\n";' | wc -l`
    eq $orig_plain_lines $morpho_sents "Number of sentences in all morpho docs"
    for_giza_lines=`zcat for_giza.gz | wc -l`
    eq $orig_plain_lines $for_giza_lines "Number of lines in for_giza.gz" 
    giza_lines=`zcat giza.gz | wc -l`
    eq $orig_plain_lines $giza_lines "Number of lines in giza.gz"
    tecto_sents=`treex Read::Treex from=@trees.tecto/list Util::Eval bundle='print "BUNDLE\n";' | wc -l`
    eq $orig_plain_lines $tecto_sents "Number of sentences in all tecto docs"
    popd
}

function _segm_data_tests {
    all_segm_sents=$1
    orig_plain_lines=`cat plain_data.* | wc -l`
    eq $all_segm_sents $orig_plain_lines "The number of lines in both parts of the orig_plain" 
    split_plain_lines=`cat data_splits/*/part_*.txt | wc -l`
    eq $all_segm_sents $split_plain_lines "The accumulated number of lines in data_splits"
    notexists "for_giza.gz"
    notexists "giza.gz"
    notexists "trees.tecto"
}

function test_para_data_analysis_2 {
    printinfo "Testing para_data_analysis up to the split_data stage on cs-en segm docs"
	make -f makefile.para_data_analysis split_data DATA="test/data/sample2.cs-en.cs.segm; test/data/sample2.cs-en.en.segm" STAGE=segm LANG_PAIR=cs_en TMP_DIR=tmp/cs_en/sample2.cs-en LRC=0
    all_segm_sents=`cat test/data/sample2.cs-en.*.segm | grep "<seg" | wc -l`
    exists "tmp/cs_en/sample2.cs-en"
	pushd tmp/cs_en/sample2.cs-en
    _segm_data_tests $all_segm_sents
    popd
}

function test_extract_table_1 {
    printinfo "Testing extract_table in tm for cs_en"
    make -f makefile.tm extract_table DATA="test/data/sample.cs-en.cs.txt; test/data/sample.cs-en.en.txt" STAGE=orig_plain TRANSL_PAIR=cs_en LRC=0
    exists "tmp/cs_en/sample.cs-en"
	pushd tmp/cs_en/sample.cs-en
    table_cols=`zcat tm_train_table.gz | awk 'BEGIN{FS="\t"};{print NF}' | sort | uniq`
    eq 5 ${table_cols:-0} "Checking the number of cols in the training table" 
    table_lines=`zcat tm_train_table.gz | wc -l`
    eq 473 ${table_lines:-0} "Checking the number of lines in the training table. It might be different due to a different alignment" 
    table_lines=`zcat tm_train_table.gz | grep "parent_lemma=zlobit_se" | wc -l`
    eq 2 ${table_lines:-0} "Checking the number of lines containing \"parent_lemma=zlobit_se\". It confirms that the translation direction is cs->en" 
    popd
}

function test_extract_table_2 {
    printinfo "Testing extract_table in tm for en_cs"
    make -f makefile.tm extract_table DATA="test/data/sample.cs-en.cs.txt; test/data/sample.cs-en.en.txt" STAGE=orig_plain TRANSL_PAIR=en_cs LRC=0
    exists "tmp/en_cs/sample.cs-en"
	pushd tmp/en_cs/sample.cs-en
    table_cols=`zcat tm_train_table.gz | awk 'BEGIN{FS="\t"};{print NF}' | sort | uniq`
    eq 5 ${table_cols:-0} "Checking the number of cols in the training table" 
    table_lines=`zcat tm_train_table.gz | wc -l`
    eq 473 ${table_lines:-0} "Checking the number of lines in the training table. It might be different due to a different alignment" 
    table_lines=`zcat tm_train_table.gz | grep "parent_lemma=remove" | wc -l`
    eq 2 ${table_lines:-0} "Checking the number of lines containing \"parent_lemma=remove\". It confirms that the translation direction is en->cs" 
    popd
}

function test_train_tm {
    printinfo "Testing train_tm in tm for en_cs"
    make -f makefile.tm train_tm DATA="test/data/sample.cs-en.cs.txt; test/data/sample.cs-en.en.txt" STAGE=orig_plain TRANSL_PAIR=en_cs ML_CONFIG_FILE=test/sample.ml.conf LRC=0
    exists "tmp/en_cs/sample.cs-en/tm_tlemma"
	pushd tmp/en_cs/sample.cs-en/tm_tlemma
    _model_tests
    popd
	pushd tmp/en_cs/sample.cs-en/tm_formeme
    _model_tests
    popd
}

function test_train_tm_from_treex_file {
    printinfo "Testing train_tm in tm for cs_en starting from a data in the tecto stage"
    make -f makefile.tm train_tm DATA="test/data/sample3.cs-en.list" STAGE=tecto TRANSL_PAIR=cs_en ML_CONFIG_FILE=test/sample.ml.conf PARA_DATA_SRC_SEL="" LRC=0
    exists "tmp/cs_en/sample3.cs-en.list"
    pushd tmp/cs_en/sample3.cs-en.list
    notexists "data_splits"
    notexists "for_giza.gz"
    notexists "giza.gz"
    notexists "trees.tecto"
    table_cols=`zcat tm_train_table.gz | awk 'BEGIN{FS="\t"};{print NF}' | sort | uniq`
    eq 5 ${table_cols:-0} "Checking the number of cols in the training table" 
    exists "tm_tlemma"
	pushd tm_tlemma
    _model_tests
    popd
    popd
}

function test_transl_models_main {
    printinfo "Testing transl_model in the main Makefile for en_cs starting from a data in the tecto stage"
    make transl_models TRAIN_DATA="test/data/sample3.cs-en.list" TRAIN_DATA_STAGE=tecto TRANSL_PAIR=en_cs ML_CONFIG_FILE="test/sample.ml.conf" PARA_DATA_SRC_SEL="" LRC=0 CONFIG_FILE=""
    exists "tmp/cs_en/sample3.cs-en.list"
    pushd tmp/cs_en/sample3.cs-en.list
    notexists "data_splits"
    notexists "for_giza.gz"
    notexists "giza.gz"
    notexists "trees.tecto"
    popd
    exists "tmp/en_cs/sample3.cs-en.list"
    pushd tmp/en_cs/sample3.cs-en.list
    table_cols=`zcat tm_train_table.gz | awk 'BEGIN{FS="\t"};{print NF}' | sort | uniq`
    eq 5 ${table_cols:-0} "Checking the number of cols in the training table"
    exists "tm_tlemma"
	pushd tm_tlemma
    _model_tests
    popd
    popd

}

function test_prepare_test_data_main_1 {
    printinfo "Testing prepare_test_data in the main Makefile for en_cs from the segm stage"
    rm -rf tmp/cs_en/sample2.cs-en
    make prepare_test_data TRANSL_PAIR=en_cs TEST_DATA="test/data/sample2.cs-en.cs.segm; test/data/sample2.cs-en.en.segm" TEST_DATA_STAGE=segm LRC=0 CONFIG_FILE=""
    all_segm_sents=`cat test/data/sample2.cs-en.*.segm | grep "<seg" | wc -l`
    exists "tmp/cs_en/sample2.cs-en"
    pushd tmp/cs_en/sample2.cs-en
    _segm_data_tests $all_segm_sents
    popd
}

function test_prepare_test_data_main_2 {
    printinfo "Testing prepare_test_data in the main Makefile for en_cs from the orig_plain stage"
    rm -rf tmp/cs_en/sample.cs-en
    make prepare_test_data TRANSL_PAIR=en_cs TEST_DATA="test/data/sample.cs-en.cs.txt; test/data/sample.cs-en.en.txt" TEST_DATA_STAGE=orig_plain LRC=0 CONFIG_FILE=""
    all_sents=`cat test/data/sample.cs-en.*.txt | wc -l`
    exists "tmp/cs_en/sample.cs-en"
    all_segm_sents=`cat tmp/cs_en/sample.cs-en/segm.* | grep "<seg" | wc -l`
    eq $all_sents $all_segm_sents "Created SEGM file contains a different number of sentences than the original plain text"
    pushd tmp/cs_en/sample.cs-en
    split_plain_lines=`cat data_splits/*/part_*.txt | wc -l`
    eq $all_sents $split_plain_lines "The accumulated number of lines in data_splits"
    notexists "for_giza.gz"
    notexists "giza.gz"
    notexists "trees.tecto"
    popd
}

function test_translate_main_1 {
    printinfo "Testing the en_cs translation in the main Makefile"
    make translate TRANSL_PAIR=en_cs \
        TRAIN_DATA="test/data/sample3.cs-en.list" TRAIN_DATA_STAGE=tecto ML_CONFIG_FILE="test/sample.ml.conf" PARA_DATA_SRC_SEL="" \
        TEST_DATA="test/data/sample2.cs-en.cs.segm; test/data/sample2.cs-en.en.segm" \
        LRC=0 D="testing sample translation" \
        CONFIG_FILE=""
    # TODO: complete the test
}

function test_translate_main_2 {
    printinfo "Testing the en_nl translation in the main Makefile"
    make translate TRANSL_PAIR=en_nl \
        TRAIN_DATA="test/data/sample.nl-en.nl.txt; test/data/sample.nl-en.en.txt" TRAIN_DATA_STAGE=orig_plain ML_CONFIG_FILE="test/sample.ml.conf" \
        TEST_DATA="test/data/sample2.nl-en.nl.segm; test/data/sample2.nl-en.en.segm" \
        LRC=0 D="testing sample en-nl translation" \
        CONFIG_FILE=""
    # TODO: complete the test
}

#    make prepare_test_data TRANSL_PAIR=en_cs TRAIN_DATA="test/data/sample3.cs-en.list" TRAIN_DATA_STAGE=tecto ML_CONFIG_FILE="test/sample.ml.conf" PARA_DATA_SRC_SEL="" \
#        TEST_DATA="$TMT_ROOT/share/data/resources/wmt/2012/test/newstest2012-src.cs.sgm; $TMT_ROOT/share/data/resources/wmt/2012/test/newstest2012-src.en.sgm" TEST_DATA_STAGE=segm LRC=0

function _model_tests {
    table_cols=`zcat tm_train_table.gz | awk 'BEGIN{FS="\t"};{print NF}' | sort | uniq`
    eq 3 $table_cols "Checking the number of cols in the training table"
    static_model_size=`zcat model.static.gz | wc -c`
    gt $static_model_size 0 "Static model is empty."
    maxent_model_size=`zcat model.maxent.gz | wc -c`
    gt $maxent_model_size 0 "Maxent model is empty."
}

function clean_tests {
    rm -rf tmp/en_cs/sample.cs-en
    rm -rf tmp/cs_en/sample.cs-en
    rm -rf tmp/cs_en/sample2.cs-en
    rm -rf tmp/cs_en/sample3.cs-en.list
    rm -rf tmp/en_cs/sample3.cs-en.list
}

cd ..
if [ _$1 == _clean ]; then
    clean_tests
fi


test_para_data_analysis_1
test_para_data_analysis_2
test_extract_table_1
test_extract_table_2
test_train_tm
test_train_tm_from_treex_file
test_transl_models_main
test_prepare_test_data_main_1
test_prepare_test_data_main_2
#test_translate_main_1
#test_translate_main_2
printok
