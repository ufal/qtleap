#!/bin/bash

source common.sh

function test_text2segm {
    origlang=cs
    bin/text2segm.pl --origlang $origlang < test/data/sample.cs-en.cs.txt > test/tmp/sample.cs-en.cs.sgm
    txt_sents=`cat test/data/sample.cs-en.cs.txt | wc -l`
    sgm_sents=`cat test/tmp/sample.cs-en.cs.sgm | grep "^<seg" | wc -l`
    eq $txt_sents $sgm_sents "Numbers of sentences in the txt file an in the sgm file differ"
    first_line_srcset=`cat test/tmp/sample.cs-en.cs.sgm | head -n 1 | grep "^<srcset" | wc -l`
    eq $first_line_srcset 1 "First line have to start with \"<srcset\""
    second_line_origlang=`cat test/tmp/sample.cs-en.cs.sgm | sed -n '2p' | sed 's/^.*origlang="\?\([^ "]*\)"\?.*$/\1/'`
    eq "$second_line_origlang" "$origlang" "The \"origlang\" parameter does not set the \"origlang\" attribute"
    last_line_srcset=`cat test/tmp/sample.cs-en.cs.sgm | tail -n 1 | grep "^</srcset>$" | wc -l`
    eq $last_line_srcset 1 "The last line should be the following: \"</srcset>\""
}

cd ..

rm -rf test/tmp
mkdir test/tmp

test_text2segm
printok

rm -rf test/tmp
