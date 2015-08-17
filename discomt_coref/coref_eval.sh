#!/bin/bash

# $1 = {posspron.all, perspron.all, relpron}

treex -p --jobs 173 -m 10G -Len \
    Read::Treex from=@$CZENG_COREF_DIR/data/en/dev.pcedt.gold.list \
    Util::Eval language=cs zone='$zone->set_selector("ref");' \
    Util::Eval language=en zone='$zone->set_selector("ref");' \
    Util::SetGlobal language=en selector=ref \
    A2W::Detokenize \
    Util::SetGlobal language=en selector=src \
    W2W::CopySentence source_language=en source_selector=ref \
    Scen::Analysis::EN \
    Util::SetGlobal language=en selector=ref \
    Align::A::MonolingualGreedy to_language=en to_selector=src \
    Align::T::CopyAlignmentFromAlayer to_language=en to_selector=src align_type=monolingual del_prev_align=0 \
    Align::T::AlignGeneratedNodes to_language=en to_selector=src \
    Write::Treex path=tmp/coref_eval/bart \
    Coref::PrepareSpecializedEval selector=ref category=$1 \
    Eval::Coref_new selector=ref > coref.res
$CZENG_COREF_DIR/eval.pl < coref.res
