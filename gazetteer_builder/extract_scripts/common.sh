function download_xz {
    url=$1
    tmp_dir=$2
    xz_file=${url##*/}
    cd $tmp_dir
    wget $URL
    tar -xvvJf $xz_file
    cd ~-
}

function download_svn {
    url=$1
    tmp_dir=$2
    url=svn://anonsvn.kde.org/home/kde/branches/stable/l10n-kde4/cs/messages
    svn co $url
}

function build_gazeteers {
    po_path=$1
    en_gazfile=$2
    otherlang_gazfile=$3
    id_prefix=$4
    find $po_path -name '*.po' -exec cat {} \; | \
        $BASH_SOURCE/po2gaz.pl $en_gazfile $otherlang_gazfile $id_prefix
}

#if [ "_$4" == "clean" ]; then
#    rm $PACKED_FILE
#    rm -rf ${PO_PATH%%/*}
#fi
