#!/usr/bin/env perl

use warnings;
use strict;
use File::Basename;
use Data::Dumper;

sub _stem_from_parallel_paths {
    my (@parallel_paths) = @_;

    my $par_str = join " ", map {my $file = fileparse($_); $file} @parallel_paths;
    return $par_str if (scalar @parallel_paths == 1);
    $par_str =~ /^(.*).* \g1.*$/;
    my $stem = $1;
    $stem =~ s/[._]$//;
    return $stem;
}

my $data_str = join " ", @ARGV;
my @lang_strs = split /;/, $data_str;
foreach my $lang_str (@lang_strs) {
    $lang_str =~ s/^\s+//;
    $lang_str =~ s/\s+$//;
}

my @lang_paths = map {[ split / /, $_ ]} @lang_strs;
my ($length, @other_lengths) = map {scalar @$_} @lang_paths;

if (!$length || grep {$_ != $length} @other_lengths) {
    print STDERR "Data string is empty or its language parts (separated by \";\") have a different number of items (separated by \" \").\n";
    exit;
}

my @file_stems = ();
for (my $i = 0; $i < $length; $i++) {
    my @parallel_paths = map {$_->[$i]} @lang_paths;
    push @file_stems, _stem_from_parallel_paths(@parallel_paths);
}

print join "_", @file_stems;
print "\n";
