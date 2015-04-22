#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long;

my $USAGE = <<USAGE;
Usage: $0 [--origlang lang] < txt_file > sgm_file
       $0 [--origlang lang] lang_txt_file en_txt_file lang_sgm_file en_sgm_file
- the latter use simultaneously discards the lines which are empty in either of the txt files
USAGE

my $origlang = "???";
GetOptions(
    "origlang=s" => \$origlang,
);

sub print_header {
    my ($fh, $lang) = @_;

    print $fh "<srcset setid=\"sample-set\" srclang=\"any\">\n";
    print $fh "<doc docid=\"sample-doc-1\" origlang=\"$lang\">\n";
}

sub print_footer {
    my ($fh) = @_;

    print $fh "</doc>\n";
    print $fh "</srcset>\n";
}

sub print_seg {
    my ($fh, $line, $i) = @_;
    
    $line =~ s/\s+$//;
    print $fh "<seg id=\"$i\">" . $line . "</seg>\n";
}

if (@ARGV == 4) {
    open my $orig_txt_file, "<", $ARGV[0];
    open my $en_txt_file, "<", $ARGV[1];
    open my $orig_sgm_file, ">", $ARGV[2];
    open my $en_sgm_file, ">", $ARGV[3];

    print_header($orig_sgm_file, $origlang);
    print_header($en_sgm_file, "en");
    
    my $i = 1;
    my $line_num = 0;
    while (my $orig_line = <$orig_txt_file>) {
        chomp $orig_line;
        my $en_line = <$en_txt_file>;
        chomp $en_line;

        $line_num++;
        if ($orig_line =~ /^\s*$/ || $en_line =~ /^\s*$/) {
            print STDERR "Line $line_num is empty in one of the input txt files.\n";
            next;
        }

        print_seg($orig_sgm_file, $orig_line, $i);
        print_seg($en_sgm_file, $en_line, $i);
        $i++;
    }

    print_footer($orig_sgm_file);
    print_footer($en_sgm_file);
    
    close $orig_sgm_file;
    close $en_sgm_file;
    close $orig_txt_file;
    close $en_txt_file;
}
elsif (@ARGV == 0) {
    print_header(\*STDOUT, $origlang);
    my $i = 1;
    while (my $line = <STDIN>) {
        chomp $line;
        print_seg(\*STDOUT, $line, $i);
        $i++;
    }
    print_footer(\*STDOUT);
}
else {
    print STDERR $USAGE;
}
