use strict;
use Test::More;
use Catmandu::Importer::HTMLTable;

new_ok(
    'Catmandu::Importer::HTMLTable' => [ { location => './t/tables.html' } ]
);
can_ok( 'Catmandu::Importer::HTMLTable', qw(each to_array) );

note('Get first table');
{
    my $importer
        = Catmandu::Importer::HTMLTable->new( location => './t/tables.html' );
    my $rows = $importer->to_array();
    is( scalar @{$rows}, 2, 'got table rows' );
    is_deeply(
        $rows->[1],
        { A => '2A', B => '2B', C => '2C' },
        'table header via <th>'
    );
}

note('Get second table');
{
    my $importer = Catmandu::Importer::HTMLTable->new(
        location => './t/tables.html',
        nr       => 2
    );
    my $rows = $importer->to_array();
    is( scalar @{$rows}, 2, 'got table rows' );
    is_deeply(
        $rows->[1],
        { A => '2D', B => '2E', C => '2F' },
        'table header via <th>'
    );
}

note('Get href');
{
    my $importer = Catmandu::Importer::HTMLTable->new(
        location => './t/tables.html',
        href     => 1
    );
    my $rows = $importer->to_array();
    is( scalar @{$rows}, 2, 'got table rows' );
    is_deeply(
        $rows->[1],
        {   A => { text => '2A' },
            B => { text => '2B' },
            C => { text => '2C', href => '/link/to/2C' }
        },
        'table header via first <tr>'
    );
}

done_testing;
