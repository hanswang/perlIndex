#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

$| = 1;

sub main
{
    my $data = get("http://www.latrobe.edu.au/courses/a-z");

# debug output
    print $data;
}

main();
