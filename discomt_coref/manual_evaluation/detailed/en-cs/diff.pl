#!/usr/bin/env perl

use strict;
use warnings;

open my $f1, "<", $ARGV[0];
open my $f2, "<", $ARGV[1];

while (my $l1 = <$f1>) {
    my $l2 = <$f2>;
    if ($l1 eq $l2) {
        print "1\n";
    } else {
        print "0\n";
    }
}

