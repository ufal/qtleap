#!/bin/bash

source `dirname $BASH_SOURCE`/../common.sh

DOWNLOADED_FILE=gazetteers.zip
TSV_PATH=gazetteerNL.tsv

EN_GAZFILE=$1
OTHERLANG_GAZFILE=$2
ID_PREFIX=$3

TMP_DIR=$4

extract_zip $DOWNLOADED_FILE $TSV_PATH $TMP_DIR
build_gazetteers_from_rosas_tsv $TSV_PATH $EN_GAZFILE $OTHERLANG_GAZFILE $ID_PREFIX $TMP_DIR
