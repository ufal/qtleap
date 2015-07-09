#!/bin/bash

URL=http://downloads.videolan.org/pub/videolan/vlc/2.1.5/vlc-2.1.5.tar.xz
PACKED_FILE=${URL##*/}
PO_PATH=vlc-2.1.5/po/cs.po

EN_GAZFILE=$1
OTHERLANG_GAZFILE=$2
ID_PREFIX=$3


wget $URL
tar -xvvJf $PACKED_FILE
find $PO_PATH -name '*.po' -exec cat {} \; | \
    ./po2gaz.pl $EN_GAZFILE $OTHERLANG_GAZFILE $ID_PREFIX

if [ "_$4" == "clean" ]; then
    rm $PACKED_FILE
    rm -rf ${PO_PATH%%/*}
fi
