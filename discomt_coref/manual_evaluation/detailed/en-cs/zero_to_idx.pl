#!/usr/bin/env perl

use strict;
use warnings;

my $i = 0;
while (<STDIN>) {
    if ($_ =~ /^0/) {
        print "$i ";
    } 
    $i++; 
}
print "\n";
