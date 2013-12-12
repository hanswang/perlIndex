#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

$| = 1;

sub main
{
    my $data = get("http://www.qut.edu.au/study/study-areas/information-technology-courses");

    print $data;
}

main();
