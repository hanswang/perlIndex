#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

$| = 1;

sub main
{
    my $data = get("http://www.qut.edu.au/study/study-areas/building-and-planning-courses");

    print $data;
}

main();
