#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long;

my $selector;
my $language;
GetOptions(
    "selector|s:s" => \$selector,
    "language|l:s" => \$language,
);

if (!defined $selector || !defined $language) {
    print STDERR "Both --selector and --language must be defined.\n";
    exit;
}

while (my $line = <STDIN>) {
    chomp $line;
    if ($selector =~ /^s/) {
        $line =~ s/^<(\/?)refset/<$1srcset/i;
    }
    elsif ($selector =~ /^r/) {
        $line =~ s/^<(\/?)srcset/<$1refset/i;
        if ($line =~ /^<refset/i && $line !~ /trglang=/i) {
            $line =~ s/>(\s*)$/ trglang="$language">$1/;
        }
        if (($line =~ /^<refset/i || $line =~ /^<doc/i) && $line !~ /sysid=/i) {
            $line =~ s/>(\s*)$/ sysid="manual">$1/;
        }
    }
    else {
        print STDERR "Possible values for --selector (-s): src, ref\n";
        exit;
    }
    
    print "$line\n";
}
