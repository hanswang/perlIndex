#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

$| = 1;

sub main
{
    my $data = get("http://www.bond.edu.au/study-at-bond/undergraduate-degrees/index.htm?myListType=1");

    print $data;
}

main();
