#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

$| = 1;

sub main
{
    my $data = get("http://www.student.qut.edu.au/studying/courses/health");

    print $data;
}

main();
