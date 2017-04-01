package Catmandu::Importer::HTMLTable;

use strict;
use 5.008_005;
our $VERSION = '0.01';

use namespace::clean;
use Catmandu::Sane;
use Catmandu::Util qw(trim);
use XML::LibXML;
use Moo;

with 'Catmandu::Importer';

has location   => ( is => 'ro', required => 1 );
has nr         => ( is => 'ro', default  => sub {'1'} );
has href       => ( is => 'ro', default  => sub {'0'} );
has table_rows => ( is => 'ro', builder  => '_build_table' );

sub _build_table {
    my ($self) = @_;
    my $dom = XML::LibXML->load_html(
        location        => $self->location,
        recover         => 1,
        suppress_errors => 1,
    );

    my @table = $self->get_table($dom);
    my @tr    = $self->get_tr( $table[ $self->nr - 1 ] );
    my @th    = $self->get_th($dom);

    if (@th) {
        shift @tr;
    }
    else {
        @th = map { $_->{text} } get_td( shift @tr );
    }
    my @table_rows;
    for my $tr (@tr) {
        my @td = $self->get_td($tr);
        my %hash;
        @hash{@th} = @td;
        push @table_rows, \%hash;
    }
    return \@table_rows;
}

sub generator {
    my ($self) = @_;
    my $n = 0;
    sub {
        $self->table_rows->[ $n++ ];
    };
}

sub get_table {
    my ( $self, $dom ) = @_;
    my @table = $dom->findnodes('//table');
    return @table;
}

sub get_th {
    my ( $self, $dom ) = @_;
    my @th = map { $_->to_literal } $dom->findnodes('.//th');
    return @th;
}

sub get_tr {
    my ( $self, $dom ) = @_;
    my @tr = $dom->findnodes('.//tr');
    return @tr;
}

sub get_td {
    my ( $self, $dom ) = @_;
    my @td;
    for my $td ( $dom->findnodes('.//td') ) {
        if ( $self->href ) {
            if ( my ($href) = $td->findnodes('./a/@href') ) {
                push @td,
                    { href => $href->to_literal, text => $td->to_literal };
            }
            else {
                push @td, { text => $td->to_literal };
            }
        }
        else {
            push @td, $td->to_literal;
        }
    }
    return @td;
}

1;

__END__

=encoding utf-8

=head1 NAME

Catmandu::Importer::HTMLTable - Imports HTML tables form file or URL

=begin markdown

[![Build Status](https://travis-ci.org/jorol/Catmandu-Importer-HTMLTable.png)](https://travis-ci.org/jorol/Catmandu-Importer-HTMLTable)
[![Coverage Status](https://coveralls.io/repos/jorol/Catmandu-Importer-HTMLTable/badge.png?branch=master)](https://coveralls.io/r/jorol/Catmandu-Importer-HTMLTable?branch=master)
[![Kwalitee Score](http://cpants.cpanauthors.org/dist/Catmandu-Importer-HTMLTable.png)](http://cpants.cpanauthors.org/dist/Catmandu-Importer-HTMLTable)
[![CPAN version](https://badge.fury.io/pl/Catmandu-Importer-HTMLTable.png)](http://badge.fury.io/pl/Catmandu-Importer-HTMLTable)

=end markdown

=head1 SYNOPSIS

    # On the command line
    $ catmandu convert HTMLTables --location ./t/tables.html to CSV
    # extract second table from HTML document
    $ catmandu convert HTMLTables --location ./t/tables.html --nr 2 to CSV
    # extract links from table cells
    $ catmandu convert HTMLTables --location ./t/tables.html --href 1 to YAML

    # Or in Perl
    use Catmandu::Importer::HTMLTable;

    my $importer = Catmandu::Importer::HTMLTable->new(location => './t/tables.html');

    my $n = $importer->each(sub {
        my $hashref = $_[0];
        # ...
    });
    
=head1 DESCRIPTION

Catmandu::Importer::HTMLTable is an L<Catmandu> importer for HTML tables.

If now no table header cells (<th>) found, cells from first table row are used as column names. 

=head1 CONFIGURATION
  
=over
  
=item location
 
The location of HTML document (file path or URL).
  
=item nr
 
If the HTML document contains more than one table you can select a specific table by its number (1,2,3,...). Default: 1.
 
=item href
 
Extract hyperlinks from table cells. Default: 0.

=back

=head1 AUTHOR

Johann Rolschewski E<lt>jorol@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2017- Johann Rolschewski

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Catmandu>, L<Catmandu::Importer>.

=cut
