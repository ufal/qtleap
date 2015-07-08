#!/bin/bash

URL=http://download.documentfoundation.org/libreoffice/src/4.4.0/libreoffice-translations-4.4.0.3.tar.xz
XZ_FILE=${URL##*/}
PO_PATH=libreoffice-4.4.0.3/translations/source/cs

PO_CONCAT_FILE=libreoffice.po_concat.po

EN_GAZFILE=en.libreoffice.gaz
OTHERLANG_GAZFILE=cs.libreoffice.gaz
ID_PREFIX=libreoffice_


#wget $URL
#tar -xvvJf $XZ_FILE
find $PO_PATH -name '*.po' -exec cat {} \; > $PO_CONCAT_FILE
./po2gaz.pl $EN_GAZFILE $OTHERLANG_GAZFILE $ID_PREFIX < $PO_CONCAT_FILE

if [ "_$1" == "clean" ]; then
    rm $XZ_FILE
    rm -rf ${URL%%/*}
fi
