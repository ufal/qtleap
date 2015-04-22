#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

sub empty_line_nums {
    my ($file) = @_;

    my @nums = ();

    my $i = 0;
    while (<$file>) { 
        chomp $_;
        if ($_ =~ /^\s*$/) {
            push @nums, $i;
        }
        $i++;
    }
    return @nums;
}

sub filter_empty {
    my ($in_file, $out_file, $empty) = @_;

    my $i = 0;
    while (<$in_file>) { 
        if (!$empty->{$i}) {
            print $out_file $_;
        }
        $i++;
    }
}

my $path1 = $ARGV[0];
my $path2 = $ARGV[1];

open my $file1, "<:utf8", $path1;
my @empty1 = empty_line_nums($file1);
close $file1;
open my $file2, "<:utf8", $path2;
my @empty2 = empty_line_nums($file2);
close $file2;

my %empty_lines = map {$_ => 1} (@empty1, @empty2);

my $out_path1 = $ARGV[2];
my $out_path2 = $ARGV[3];

open $file1, "<:utf8", $path1;
open my $out_file1, ">:utf8", $out_path1;
filter_empty($file1, $out_file1, \%empty_lines);
close $file1;
close $out_file1;

open $file2, "<:utf8", $path2;
open my $out_file2, ">:utf8", $out_path2;
filter_empty($file2, $out_file2, \%empty_lines);
close $file2;
close $out_file2;
