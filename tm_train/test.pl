#!/usr/bin/env perl

use strict;
use warnings;

use Treex::Core::Common;

use Treex::Tool::TranslationModel::Factory;

use Getopt::Long;

########################## PARAMS #############################

my $USAGE = <<"USAGE_END";
Usage: $0 [ flags ] <model_type=static|maxent|vw> <model_file>
Flags: 
\t-s, --source_column=NUM\t\tindex of the column with source labels (default = 0)
\t-t, --target_column=NUM\t\tindex of the column with target labels (default = 1)
\t--feature_column=NUM\t\tindex of the column with features (default = 2)
USAGE_END

my $source_column = 0;
my $target_column = 1;
my $feature_column = 2;

GetOptions(
    "source_column|s=i" => \$source_column,
    "target_column|t=i" => \$target_column,
    "feature_column=i" => \$feature_column,
);

if (@ARGV < 1) {
    log_fatal $USAGE;
}
my $model_type = shift @ARGV;
my $modelfile = shift @ARGV;

##################################################################

binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";

my $model_factory = Treex::Tool::TranslationModel::Factory->new();
my $model = $model_factory->create_model($model_type);
$model->load_specified($modelfile);

while (<STDIN>) {
    chomp $_;
    my @p = split /\t/, $_;
    my ($input, $output, $feature_str) = ($p[$source_column], $p[$target_column], $p[$feature_column]);

    my (@features) = split / /, $feature_str;

    my @trans = map {$_->{label}} $model->get_translations($input, \@features);
    my $output_pred = "<NOTHING>";
    if (@trans > 0) {
        $output_pred = $trans[0];
    }
    else {
        print STDERR "ZERO: $input\n";
    }

    
    #my $max = 3;
    #if (@trans < $max) {
    #    $max = scalar @trans;
    #}
    #print $cs_val . "\t" . (join "\t", @trans[0 .. $max-1]) . "\n";
    
    print $output_pred . "\t" . $output . "\n";
}
