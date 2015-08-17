#!/usr/bin/env perl

use strict;
use warnings;

my %all_idx = map {$_ => 1} @ARGV;

my $i = 0;

while (my $line = <STDIN>) {
    if ($line =~ /^\s*$/) {
        $i++;
    }
    print $line if ($all_idx{$i});
}
