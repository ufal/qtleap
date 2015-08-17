#!/bin/bash


function print_sents {
    from=$1
    
    print_eval='my @f;
                
                push @f, "ID: ".$tnode->get_address;
                
                my $src_anode = $tnode->get_lex_anode;
                push @f, "SRC_FORM: ".$src_anode->form;
                
                my @tst_tnodes = $tnode->get_bundle->get_zone("cs","tst")->get_ttree->get_descendants();
                my ($tst_tnode) = grep {defined $_->src_tnode && ($_->src_tnode == $tnode)} @tst_tnodes;
                my $tst_form = "undef";
                my $tst_lex_anode;
                if ($tst_tnode) {
                    $tst_lex_anode = $tst_tnode->get_lex_anode;
                    if (defined $tst_lex_anode) {
                        $tst_form = $tst_lex_anode->form;
                    }
                    else {
                        my $gen = $tst_tnode->gram_gender || "undef";
                        my $num = $tst_tnode->gram_number || "undef";
                        $tst_form = "TLEMMA: ".$tst_tnode->t_lemma.":$gen:$num";
                    }
                }
                push @f, "TST_FORM: ".$tst_form;

                my $sent_pos = $tnode->get_bundle->get_position();
                my @bundles = $tnode->get_document->get_bundles;
                
                if ($sent_pos > 1) {
                    push @f, "SRC_SENT_2: ".$bundles[$sent_pos-2]->get_zone("en","src")->sentence;
                }
                if ($sent_pos > 0) {
                    push @f, "SRC_SENT_1: ".$bundles[$sent_pos-1]->get_zone("en","src")->sentence;
                }
                push @f, "SRC_SENT_0: ".(join " ", map {$_ == $src_anode ? "<".$_->form.">" : $_->form } $src_anode->get_root->get_descendants({ordered => 1}));
                
                if ($sent_pos > 1) {
                    push @f, "TST_SENT_2: ".$bundles[$sent_pos-2]->get_zone("cs","tst")->sentence;
                }
                if ($sent_pos > 0) {
                    push @f, "TST_SENT_1: ".$bundles[$sent_pos-1]->get_zone("cs","tst")->sentence;
                }
                if (defined $tst_lex_anode) {
                    push @f, "TST_SENT_0: ".(join " ", map {$_ == $tst_lex_anode ? "<".$_->form.">" : $_->form } $tst_lex_anode->get_root->get_descendants({ordered => 1}));
                }
                else {
                    push @f, "TST_SENT_0: ".$bundles[$sent_pos]->get_zone("cs","tst")->sentence;
                }

                if ($sent_pos > 1) {
                    push @f, "REF_SENT_2: ".$bundles[$sent_pos-2]->get_zone("cs","ref")->sentence;
                }
                if ($sent_pos > 0) {
                    push @f, "REF_SENT_1: ".$bundles[$sent_pos-1]->get_zone("cs","ref")->sentence;
                }
                push @f, "REF_SENT_0: ".$bundles[$sent_pos]->get_zone("cs","ref")->sentence;

                print join "\n", @f;
                print "\n\n";'

    relpron_eval='use Treex::Tool::Coreference::NodeFilter::RelPron;
            if (Treex::Tool::Coreference::NodeFilter::RelPron::is_relat($tnode)) {'"$print_eval"'};'


    perspron_eval='my $anode = $tnode->get_lex_anode;
            if (defined $anode && ($anode->tag eq "PRP")) {'"$print_eval"'};'

    posspron_eval='my $anode = $tnode->get_lex_anode;
            if (defined $anode && ($anode->tag eq "PRP\$")) {'"$print_eval"'};'

    if [ $2 == "relat" ]; then
        eval_str=$relpron_eval;
    elif [ $2 == "pers" ]; then
        eval_str=$perspron_eval;
    elif [ $2 == "poss" ]; then
        eval_str=$posspron_eval;
    else
        exit "Unknown option: $2";
    fi
    
    treex -p --jobs 20 -Len -Ssrc \
        Read::Treex from=!$from \
        Util::Eval tnode="'"$eval_str"'"
}

         #'newstest2012_coref/runs/006_2015-08-07_14-41-23' \
         #'newstest2012_coref/runs/007_2015-08-07_14-45-52' \
         #'newstest2012_coref/runs/008_2015-08-07_14-50-19' \
         #'newstest2012_coref/runs/010_2015-08-07_15-06-11' \
         #'newstest2012_coref/runs/011_2015-08-07_15-17-24' \
         #'batch2a_coref/runs/006_2015-08-06_16-41-31' \
         #'batch2a_coref/runs/007_2015-08-06_16-50-09' \
         #'batch2a_coref/runs/008_2015-08-06_16-58-15' \
         #'batch2a_coref/runs/009_2015-08-06_17-08-08' \
         #'batch2a_coref/runs/012_2015-08-06_17-30-53' \
for i in 'newstest2012_coref/runs/006_2015-08-07_14-41-23' \
        'newstest2012_coref/runs/008_2015-08-07_14-50-19' \
        'newstest2012_coref/runs/010_2015-08-07_15-06-11' \
        'newstest2012_coref2/runs/007_2015-08-12_07-17-15'; do
    echo "$i"
    #for j in 'relat' 'pers' 'poss'; do
    for j in 'pers'; do
        data=`echo "$i" | cut -f1 -d'/'`
        typ=`echo "$i" | cut -f3 -d'/'`
        print_sents "$i/treexfiles/*.streex" $j > $data.$typ.$j.log
    done
done
