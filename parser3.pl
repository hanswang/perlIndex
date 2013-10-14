#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use JSON qw( decode_json );

$| = 1;

sub main
{
    open (DATA, "<majorList.json") or die "Can't oepn data";
    while (<DATA>)
    {   
        my $data = $_; 
        chomp($data);

        my $decoded_json = decode_json($data);
        # print Dumper $decoded_json;

        my @majors = @{$decoded_json->{'Items'}};

        foreach my $major (@majors) {
            print $major->{'Name'}
                . "\n";
        }
    }   

    close (DATA);

}

main();
