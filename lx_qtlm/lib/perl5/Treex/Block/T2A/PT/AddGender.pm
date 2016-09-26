package Treex::Block::T2A::PT::AddGender;
use Moose;
use Treex::Tool::LXSuite;
use Treex::Core::Common;
use Treex::Tool::LXSuite;

extends 'Treex::Core::Block';

has lxsuite => ( is => 'ro', isa => 'Treex::Tool::LXSuite', default => sub { return Treex::Tool::LXSuite->new; }, required => 1, lazy => 0 );

sub process_anode {
	my ( $self, $anode ) = @_;

	return if ($anode->lemma !~ /^[[:alpha:]]+$/);

	#TODO Handle of numerals
	return if ($anode->iset->pos !~ m/(noun|adj)/);

	my $lxpos = "CN";
	if ($anode->iset->pos =~ m/adj/) {
		$lxpos = "ADJ";
	} 
	my $feats = $self->lxsuite->feat(lc $anode->lemma, $lxpos);

	#By default the portuguese gender is set to masculine
	if ($feats !~ /^(m|f)/){
		log_warn $anode->lemma . " género por defeito...";
		$anode->iset->set_gender('masc');
	}
	else{

		$anode->iset->set_gender('masc') 	if ($feats =~ /^m/);
		$anode->iset->set_gender('fem') 	if ($feats =~ /^f/);
	}
	
	return;
}

1;

__END__

=encoding utf-8

=head1 NAME

Treex::Block::T2A::PT::AddGender

=head1 DESCRIPTION

Runs the form, lemma and other attributes of a noun or adjective through the LX-Suite tagger 
extracting the gender from the resulting annotation

=head1 AUTHORS

João A. Rodrigues <jrodrigues@di.fc.ul.pt>

Luís Gomes <luis.gomes@di.fc.ul.pt>, <luismsgomes@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright © 2015 by NLX Group, Universidade de Lisboa

Copyright © 2008 by Institute of Formal and Applied Linguistics, Charles University in Prague

This module is free software; you can redistribute it and/or modify it under the same terms as Perl itself.



