function download_xz {
    url=$1
    subdir=$2
    tmp_dir=${3-.}
    xz_file=${url##*/}
    cd $tmp_dir
    wget $url -O $xz_file
    tar -xvvJf $xz_file $subdir
    cd ~-
}

function download_svn {
    url=$1
    tmp_dir=$2
    svn co $url $tmp_dir
}

function extract_zip {
    zip_file=$1
    subdir=$2
    tmp_dir=${3-.}
    cd $tmp_dir
    if [ ! -e $zip_file ]; then
        echo "The file $tmp_dir/$zip_file is missing. Ask Michal Novák <mnovak@ufal.mff.cuni.cz> to get it." >&2
        exit 1
    fi
    unzip -o $zip_file $subdir
    cd ~-
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

function build_gazetteers_from_rosas_tsv {
    tsv_path=$1
    en_gazfile=$2
    otherlang_gazfile=$3
    id_prefix=$4
    tmp_dir=${5-.}
    `dirname $BASH_SOURCE`/rosa_tsv2gaz.pl $en_gazfile $otherlang_gazfile $id_prefix < $tmp_dir/$tsv_path
}

#if [ "_$4" == "clean" ]; then
#    rm $PACKED_FILE
#    rm -rf ${PO_PATH%%/*}
#fi
