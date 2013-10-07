use strict;
use warnings;
use Data::Dumper;
use JSON qw( decode_json );

$| = 1;

sub main
{
    open (DATA, "<courseList.json") or die "Can't oepn data";
    while (<DATA>)
    {   
        my $data = $_; 
        chomp($data);

        my $decoded_json = decode_json($data);

        print Dumper $decoded_json;
    }   

    close (DATA);

}

main();
