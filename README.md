# NAME

Catmandu::Importer::HTMLTable - Imports HTML tables form file or URL 

# SYNOPSIS

    $ catmandu convert HTMLTables --location ./t/tables.html
    # extract second table from HTML document
    $ catmandu convert HTMLTables --location ./t/tables.html --nr 2
    # extract links from table cells
    $ catmandu convert HTMLTables --location ./t/tables.html --href 1

    # Or in Perl
    use Catmandu::Importer::HTMLTable;

    my $importer = Catmandu::Importer::HTMLTable->new(location => './t/tables.html');

    my $n = $importer->each(sub {
        my $hashref = $_[0];
        # ...
    });
    

# DESCRIPTION

Catmandu::Importer::HTMLTable is an [Catmandu](https://metacpan.org/pod/Catmandu) importer for HTML tables.

If now no table header cells (&lt;th>) found, cells from first table row are used as column names. 

# CONFIGURATION

- location

    The location of HTML document (file path or URL).

- nr

    If the HTML document contains more than one table you can select a specific table by its number (1,2,3,...). Default: 1.

- href

    Extract hyperlinks from table cells. Default: 0.

# AUTHOR

Johann Rolschewski <jorol@cpan.org>

# COPYRIGHT

Copyright 2017- Johann Rolschewski

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
