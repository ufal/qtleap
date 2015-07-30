#!/bin/bash

source `dirname $BASH_SOURCE`/../common.sh

URL=svn://anonsvn.kde.org/home/kde/branches/stable/l10n-kde4/cs/messages
PO_PATH=kde4

EN_GAZFILE=$1
OTHERLANG_GAZFILE=$2
ID_PREFIX=$3

TMP_DIR=$4

download_svn $URL ${TMP_DIR-.}/$PO_PATH
build_gazeteers $PO_PATH $EN_GAZFILE $OTHERLANG_GAZFILE $ID_PREFIX $TMP_DIR
