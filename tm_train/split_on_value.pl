#!/usr/bin/env perl

use warnings;
use strict;

binmode STDIN, "utf8";

my $usage = "$0 <part_size> <prefix>";

if (@ARGV < 2) {
    die $usage;
}

my $part_size = $ARGV[0];
my $file_prefix = $ARGV[1];

my $out_part_file;
my $part_id = 1;

my $filename = $file_prefix."_".sprintf("%.3d", $part_id);
open $out_part_file, ">:gzip:utf8", $filename or die "Cannot open $filename";
print STDERR "Printing into $filename\n";

my $prev_val = undef;
my $i = 0;
while (my $line = <STDIN>) {
    chomp $line;
    my ($en_val) = split /\t/, $line;
    
    if (($i >= $part_size) && (!defined $prev_val || ($prev_val ne $en_val))) {
        close $out_part_file;
        $part_id++;
        $filename = $file_prefix."_".sprintf("%.3d", $part_id);
        open $out_part_file, ">:gzip:utf8", $filename  or die "Cannot open $filename";
        print STDERR "Printing into $filename\n";
        $i = 0;
    }
    print $out_part_file "$line\n";
    $i++;
    $prev_val = $en_val;
}
close $out_part_file;
