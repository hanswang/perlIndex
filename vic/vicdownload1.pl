#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

$| = 1;

sub main
{
    my $data = get("http://www.vu.edu.au/courses/browse-for-courses/all-courses-a-to-z");

    print $data;
}

main();
