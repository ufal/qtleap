#!/bin/bash

script_dir=`dirname "$0"`

source $script_dir/../common.sh

URL=http://downloads.videolan.org/pub/videolan/vlc/2.1.5/vlc-2.1.5.tar.xz
PO_PATH=vlc-2.1.5/po/cs.po

EN_GAZFILE=$1
OTHERLANG_GAZFILE=$2
ID_PREFIX=$3

TMP_DIR=${4-.}

download_extract_xz $URL
build_gazeteers $PO_PATH $EN_GAZFILE $OTHERLANG_GAZFILE $ID_PREFIX $TMP_DIR
