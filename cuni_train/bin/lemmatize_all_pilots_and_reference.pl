#!/usr/bin/env perl
use strict;
use warnings;

#my $TREEX= 'treex';
my $TREEX= 'treex -p -j1';
my @PILOTS = qw(0 1);
my @BATCHES = qw(2a 2q);
my @LANGS = qw(bg cs de es eu nl pt);
my %SCENARIO = (
  en => 'W2A::EN::Tokenize W2A::EN::TagMorce W2A::EN::Lemmatize',
  cs => 'W2A::CS::Tokenize W2A::CS::TagMorphoDiTa lemmatize=1',
  es => 'W2A::ES::Tokenize W2A::ES::TagAndParse',
  eu => 'W2A::EU::Tokenize W2A::EU::TagAndParse', # installed_tools/eustagger/bin/eustagger_lite must be installed according to D2.3 pdf
  #nl => 'W2A::NL::Tokenize A2P::NL::ParseAlpino', # Alpino is sooooo slow
  #pt => 'Util::SetGlobal lxsuite_host=194.117.45.198 lxsuite_port=10000 lxsuite_key=LXSUITE_KEY_PLACEHOLDER W2A::PT::TokenizeAndTag W2A::PT::FixTags',
);
my %done;

sub lemmatize {
    my ($lang, $file) = @_;
    my $scen = $SCENARIO{$lang};
    if (!$scen){
        warn "No lemmatization scenario for $lang. Skipping $file.\n";
        return;
    }
    my $finished = $file;
    $finished =~ s/.txt(.gz)?/_lemmatized.conll/;
    print "Checking $finished and $finished.gz\n";
    if ((-f $finished) || (-f "$finished.gz")) {
        print "$finished was already done, skipping\n";
        return;
    }
    
    # most lemmatization scenarios are OK with the (treex -p) default 2 GiB memory,
    # but Spanish IXA-Pipe needs more (because it runs also the parser).
    my $mem = '';
    if ($lang eq 'es'){
      $mem = '--mem=6G';
    } elsif ($lang eq 'eu'){
      $mem = '--mem=10G';
    }
    
    my $command = "$TREEX $mem -L$lang Read::Sentences from=$file $scen Write::CoNLLX substitute='{.conll}{_lemmatized.conll}' > $file.log 2>&1 &";
    print "$command\n";
    system "$command";
    return;
}

foreach my $batch (@BATCHES) {
    # reference translations
    foreach my $lang (keys %SCENARIO) {
        lemmatize($lang, "corpus/Batch${batch}_${lang}_v1.txt");
    }
    # MT output (Pilot translations)
    foreach my $pilot (@PILOTS) {
        foreach my $lang (@LANGS) {
            next if $pilot eq '0c' && $lang ne 'es';
            my ($src_lang, $trg_lang) = $batch =~ /a/ ? ('en', $lang) : ($lang, 'en');
            lemmatize($trg_lang, "corpus/pilot$pilot-$src_lang-$trg_lang-batch$batch.txt.gz");
        }
    }
}
