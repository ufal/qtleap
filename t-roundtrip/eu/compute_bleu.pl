#!/usr/bin/env perl

use warnings;
use strict;
use utf8;
use autodie;
binmode STDOUT, ':encoding(utf8)';
binmode STDIN, ':encoding(utf8)';

use Getopt::Long;
use Treex::Tool::Eval::Bleu;

my ( $PRINT_NGRAM, $INDIVIDUAL ) = ( 3, 1 );

GetOptions(
    'print_ngram=i'    => \$PRINT_NGRAM,
    'print_individual' => \$INDIVIDUAL,
);

my ( $ref, $tst, $x );
while (<>) {
    ( $x, $ref ) = split /\t/ if /^REF/;
    if (/^TST/) {
        ( $x, $tst ) = split /\t/;
        Treex::Tool::Eval::Bleu::add_segment( $tst, $ref );
    }
}

for my $ngram ( 1 .. $PRINT_NGRAM ) {
    print_ngram_diff( $ngram, 6 );
}

sub print_ngram_diff {
    my ( $n, $limit ) = @_;
    my ( $miss_ref, $extra_ref ) = Treex::Tool::Eval::Bleu::get_diff( $n, $limit, $limit );
    print "________ Top missing $n-grams: ________   ________ Top extra $n-grams: ________\n";
    for my $i ( 0 .. $limit - 1 ) {
        printf "%30s %5d %30s %6d\n",
            $miss_ref->[$i][0], $miss_ref->[$i][1], $extra_ref->[$i][0], $extra_ref->[$i][1];
    }
    return;
}

if ($INDIVIDUAL) {
    print "\nIndividual n-gram precisions:\n";
    print "1    2    3    4\n";
    printf "%1.2f %1.2f %1.2f %1.2f\n\n", Treex::Tool::Eval::Bleu::get_individual_ngram_prec();
}

my $bleu = Treex::Tool::Eval::Bleu::get_bleu();
my $bp   = Treex::Tool::Eval::Bleu::get_brevity_penalty();
printf "BLEU = %2.4f  (brevity penalty = %1.5f)\n", $bleu, $bp;
