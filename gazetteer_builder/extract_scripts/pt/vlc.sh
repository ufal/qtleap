#!/bin/bash

source `dirname $BASH_SOURCE`/../common.sh

URL=http://downloads.videolan.org/pub/videolan/vlc/2.1.5/vlc-2.1.5.tar.xz
PO_PATH=vlc-2.1.5/po/pt_PT.po

EN_GAZFILE=$1
OTHERLANG_GAZFILE=$2
ID_PREFIX=$3

TMP_DIR=$4

download_xz $URL $PO_PATH $TMP_DIR
build_gazeteers $PO_PATH $EN_GAZFILE $OTHERLANG_GAZFILE $ID_PREFIX $TMP_DIR
