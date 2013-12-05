#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use Data::Dumper;

$| = 1;

sub main
{
    my $ua = LWP::UserAgent->new();
    my $url = 'http://programfinder.federation.edu.au/ProgramFinder//SearchXML';
    my $response = $ua->post($url, {'searchIn'=>'availability', 'criteria'=>'all'});
    my $data = $response->decoded_content();

# debug output
    print $data;
}

main();
