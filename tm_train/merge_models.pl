#!/usr/bin/env perl

use warnings;
use strict;

use Treex::Core::Common;

use Treex::Tool::TranslationModel::Factory;

my $USAGE = <<"USAGE_END";

Usage: $0 <model_type=static|maxent|vw> <model_parts_dir> <merged_model_file>
USAGE_END

if (@ARGV < 3) {
    log_fatal $USAGE;
}

#TODO: model_type must be here in the actual implementation
my $model_type = $ARGV[0];
my $models_dir = $ARGV[1];
my $model_path = $ARGV[2];

if (!-d $models_dir) {
    log_fatal "Directory $models_dir does not exist";
}

my @models_paths = glob "$models_dir/*";
#my @models_paths = glob "$models_dir/part_00*";

if (@models_paths == 0) {
    log_fatal "Directory $models_dir is empty";
}

my $model_factory = Treex::Tool::TranslationModel::Factory->new();

my $whole_model = $model_factory->create_model($model_type);

foreach my $models_path (@models_paths) {
    my $part_model = $model_factory->create_model($model_type);
    $part_model->load($models_path);

    foreach my $label ($part_model->get_input_labels) {
        # print STDERR $label . " ";
        my $submodel = $part_model->get_submodel($label);
        $whole_model->add_submodel($label, $submodel);
    }
}

$whole_model->save($model_path);
