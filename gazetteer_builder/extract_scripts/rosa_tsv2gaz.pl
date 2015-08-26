#!/usr/bin/env perl

use strict;
use warnings;

sub filter_transform {
    my ($en_phrase, $xx_phrase) = @_;

    return undef if ($en_phrase =~ /#/);

    $en_phrase = transform_single($en_phrase);
    $xx_phrase = transform_single($xx_phrase);

    return ($en_phrase, $xx_phrase);
}

sub transform_single {
    my ($phrase) = @_;

    $phrase =~ s/^"(.*)"$/$1/;
    $phrase =~ s/\(.*\)$//;

    return $phrase;
}


my $en_gaz_file = $ARGV[0];
my $xx_gaz_file = $ARGV[1];
my $id_prefix = $ARGV[2];

open my $en_gaz_fh, ">:utf8", $en_gaz_file;
open my $xx_gaz_fh, ">:utf8", $xx_gaz_file;

binmode STDIN, ":utf8";

# throw out the title
my $line = <STDIN>;

while ($line = <STDIN>) {
    chomp $line;
    my ($deep, $id, $en_phrase, $xx_phrase) = split /\t/, $line;

    ($en_phrase, $xx_phrase) = filter_transform($en_phrase, $xx_phrase);
    next if (!defined $en_phrase);

    print $en_gaz_fh join "\t", ($id_prefix."deep".$deep."_".$id, $en_phrase);
    print $en_gaz_fh "\n";
    print $xx_gaz_fh join "\t", ($id_prefix."deep".$deep."_".$id, $xx_phrase);
    print $xx_gaz_fh "\n";
}
