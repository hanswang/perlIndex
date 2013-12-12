#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

$| = 1;

sub main
{
    my $data = get("http://www.usc.edu.au/study/courses-and-programs/bachelor-degrees-undergraduate-programs/bachelor-degrees-list");

    print $data;
}

main();
