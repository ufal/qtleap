#!/usr/bin/env perl

use strict;
use warnings;

srand(1986); 
my %idx = ();
while (keys %idx < $ARGV[1]) {
    my $key = int(rand $ARGV[0]); 
    $idx{$key} = 1;
} 
print join " ", sort {$a <=> $b} keys %idx;
print "\n";
