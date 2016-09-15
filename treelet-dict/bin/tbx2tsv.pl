#!/usr/bin/env perl
use Treex::Block::T2T::TbxParser;

$num_args = $#ARGV + 1;
if ($num_args != 3) {
    print "\nUsage: tbx2tsv.pl dictionary src-id trg-id\n";
    exit;
}

my @entries = Treex::Block::T2T::TbxParser->parse_tbx($ARGV[0], $ARGV[1], $ARGV[2]);
foreach my $entry (@entries) {
    print $entry->{SRC_TEXT} . "\t" . $entry->{TRG_TEXT} . "\n";
}
