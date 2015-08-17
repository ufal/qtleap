#!/usr/bin/env perl

use strict;
use warnings;

binmode STDIN, ":utf8";

my $prefix = $ARGV[0] || "part_";

my $curr_out_f = undef;
my $doc_no = 1;
while (my $line = <STDIN>) {
    if ($line =~ /^<doc/) {
        if (defined $curr_out_f) {
            close $curr_out_f;
            $doc_no++;
        }
        open $curr_out_f, ">:utf8", $prefix.sprintf("%03d", $doc_no);
    }
    if (defined $curr_out_f) {
        next if ($line !~ /^<seg/);
        $line =~ s/^<seg[^>]+>//;
        $line =~ s|</seg>$||;
        print $curr_out_f $line;
    }
}
close $curr_out_f;
