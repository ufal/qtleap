#!/bin/bash

source `dirname $BASH_SOURCE`/../common.sh

URL=http://download.documentfoundation.org/libreoffice/src/4.4.0/libreoffice-translations-4.4.0.3.tar.xz
PO_PATH=libreoffice-4.4.0.3/translations/source/cs

EN_GAZFILE=$1
OTHERLANG_GAZFILE=$2
ID_PREFIX=$3

TMP_DIR=$4

download_xz $URL $PO_PATH $TMP_DIR
build_gazeteers $PO_PATH $EN_GAZFILE $OTHERLANG_GAZFILE $ID_PREFIX $TMP_DIR
