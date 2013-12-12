#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

$| = 1;

sub main
{
    my $data = get("http://www.qut.edu.au/study/study-areas/science-and-mathematics-courses");

    print $data;
}

main();
