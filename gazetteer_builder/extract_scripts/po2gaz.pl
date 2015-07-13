#!/usr/bin/env perl

use strict;
use warnings;


my $USAGE = <<USAGE;
Extract items from the software localization files (.po files) and save them 
in two gazetteer files (.gaz files), one for English phrases, one for phrases 
in the other language. Every item is assigned an ID, under which it can be 
looked up in both files. An ID prefix must be specified by a user. Localization
files (possibly concatenated) are read from STDIN.

Usage:
$0 <english_gaz_file> <otherlang_gaz_file> <id_prefix>
USAGE


# HACK!!! THESE ITEMS ARE OMMITED FROM GAZETTEERS
my %OMMITED_EN = map {$_ => 1} ("Your names", "Your emails", "Windows");



sub print_both_items {
    my ($id, $en_fh, $en_str, $lang_fh, $lang_str, $id_name) = @_;
    return $id if (!$en_str || !$lang_str);
    return $id if ($OMMITED_EN{$en_str});
    
    print_item($en_fh, $id, $en_str, $id_name);
    print_item($lang_fh, $id, $lang_str, $id_name);
    $id++;
    if ($en_str =~ /&/ || $lang_str =~ /&/) {
        $en_str =~ s/&//g;
        $lang_str =~ s/&//g;
        print_item($en_fh, $id, $en_str, $id_name);
        print_item($lang_fh, $id, $lang_str, $id_name);
        $id++;
    }
    return $id;
}

sub print_item {
    my ($fh, $id, $item, $id_name) = @_;
    
    $item =~ s/\\n/ /g;
    $item =~ s/\\//g;
    print {$fh} join "\t", ($id_name.$id, $item);
    print {$fh} "\n";
}

if (@ARGV < 3) {
    print STDERR $USAGE;
    exit 1;
}



print STDERR $ARGV[0] . "\n";
open my $en_fh, ">", $ARGV[0] or die $!;
open my $lang_fh, ">", $ARGV[1] or die $!;

my $id_name = $ARGV[2];

my $en_str;
my $lang_str;

my $en_str_ready = 0;
my $lang_str_ready = 0;

my $id = 1;

while (<STDIN>) {
    chomp $_;

    next if ($_ =~ /^#/);

    if ($_ =~ /^msgid\s+"(.*)"\s*$/) {
        $lang_str_ready = 1;
        $en_str_ready = 0;
        $id = print_both_items($id, $en_fh, $en_str, $lang_fh, $lang_str, $id_name);
        $en_str = $1;
    }
    elsif ($_ =~ /^msgstr\s+"(.*)"\s*$/) {
        $en_str_ready = 1;
        $lang_str_ready = 0;
        $lang_str = $1;
    }
    elsif ($_ =~ /^"(.*)"\s*$/) {
        if (!$en_str_ready) {
            $en_str .= $1;
        }
        elsif (!$lang_str_ready) {
            $lang_str .= $1;
        }
    }
    else {
        $lang_str_ready = 1;
        $en_str_ready = 1;
    }
}
$id = print_both_items($id, $en_fh, $en_str, $lang_fh, $lang_str, $id_name);
