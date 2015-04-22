function printinfo {
    echo -e "\e[36m$1\e[0m" >&2
}

function printerr {
    echo -e "\e[31m$1\e[0m" >&2
}

function printok {
    echo -e "\e[92mAll tests ran successfully.\e[0m" >&2
}

function exists {
    if [ ! -e $1 ]; then
        printerr "File or dir $1 does not exist."
        exit 1
    fi
}

function notexists {
    if [ -e $1 ]; then
        printerr "File or dir $1 exists but it should not."
        exit 1
    fi
}

function eq {
    if [ ! $1 == $2 ]; then
        printerr "Equality test failed: $1 != $2. Test desc: $3"
        exit 1
    fi
}
function gt {
    if [ ! $1 > $2 ]; then
        printerr "Greater-than test failed: $1 <= $2. Test desc: $3"
        exit 1
    fi
}
