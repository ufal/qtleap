package Treex::Block::W2A::PT::LXSuite;
use Moose;
use File::Basename;
use Frontier::Client;
use Encode;
use Treex::Tool::LXSuite;

extends 'Treex::Core::Block';

has lxsuite => ( is => 'ro', isa => 'Treex::Tool::LXSuite', default => sub { return Treex::Tool::LXSuite->new; }, required => 1, lazy => 0 );

sub _build_lxsuite {
    return Treex::Tool::LXSuite->new();
}

sub process_zone {
    my ( $self, $zone ) = @_;

    my $tokens = $self->lxsuite->analyse($zone->sentence);

    my $a_root = $zone->create_atree();
    # create nodes
    my $i = 1;
    my @a_nodes = map { $a_root->create_child({
        "form"         => $_->{"form"},
        "ord"          => $i++,
        "lemma"        => ($_->{"lemma"} // uc $_->{"form"}),
        "conll/pos"    => $_->{"pos"},
        "conll/cpos"   => $_->{"pos"},
        "conll/feat"   => $_->{"infl"} // '',
        "conll/deprel" => $_->{"udeprel"},
    }); } @$tokens;

    # build tree
    my @roots = ();
    while (my ($i, $token) = each @$tokens) {
        if ($token->{"form"} =~ /^\pP$/) {
            if ($i > 0 and ($token->{"space"} // "") !~ "L") {
                $a_nodes[$i-1]->set_no_space_after(1);
            }
            $a_nodes[$i]->set_no_space_after(($token->{"space"} // "") !~ "R");
        } elsif ($token->{"form"} =~ /_$/) {
            $a_nodes[$i]->set_no_space_after(1);
        }
        if ($token->{"parent"} && (int $token->{"parent"}) <= scalar @a_nodes) {
            $a_nodes[$i]->set_parent(@a_nodes[(int $token->{"parent"})-1]);
        } else {
            push @roots, $a_nodes[$i];
        }
    }

    return @roots;
}

1;

__END__

=encoding utf-8

=head1 NAME 

Treex::Block::W2A::PT::Tokenize

=head1 DESCRIPTION

Uses LX-Suite tokenizer to split a sentence into a sequence of tokens.

=head1 AUTHORS

Luís Gomes <luis.gomes@di.fc.ul.pt>, <luismsgomes@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright © 2014 by NLX Group, Universidade de Lisboa
