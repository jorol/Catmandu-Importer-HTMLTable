requires 'perl', '5.008005';

requires 'Catmandu', '0';
requires 'XML::LibXML', '0';

on test => sub {
    requires 'Test::More', '0.96';
};
