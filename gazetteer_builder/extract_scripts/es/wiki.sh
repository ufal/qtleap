#!/bin/bash

source `dirname $BASH_SOURCE`/../common.sh

URL=http://ufallab.ms.mff.cuni.cz/tectomt/share/data/models/gazeteer/wiki_all.zip
TSV_PATH=gazetteerES.tsv

EN_GAZFILE=$1
OTHERLANG_GAZFILE=$2
ID_PREFIX=$3

TMP_DIR=$4

download_zip $URL $TSV_PATH $TMP_DIR
build_gazetteers_from_rosas_tsv $TSV_PATH $EN_GAZFILE $OTHERLANG_GAZFILE $ID_PREFIX $TMP_DIR
