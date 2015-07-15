function download_xz {
    url=$1
    subdir=$2
    tmp_dir=${3-.}
    xz_file=${url##*/}
    cd $tmp_dir
    wget $URL
    tar -xvvJf $xz_file $subdir
    cd ~-
}

function download_svn {
    url=$1
    tmp_dir=$2
    svn co $url $tmp_dir
}

function build_gazeteers {
    po_path=$1
    en_gazfile=$2
    otherlang_gazfile=$3
    id_prefix=$4
    tmp_dir=${5-.}
    if [[ "$po_path" == *.po ]]; then
        cat $tmp_dir/$po_path
    else
        find $tmp_dir/$po_path -name '*.po' -exec cat {} \;
    fi | \
        `dirname $BASH_SOURCE`/po2gaz.pl $en_gazfile $otherlang_gazfile $id_prefix
}

#if [ "_$4" == "clean" ]; then
#    rm $PACKED_FILE
#    rm -rf ${PO_PATH%%/*}
#fi
