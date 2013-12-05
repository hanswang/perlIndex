#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

$| = 1;

sub main
{
    my $data = get("http://www.handbook.unsw.edu.au/vbook2014/brProgramsByAtoZ.jsp?StudyLevel=Research&descr=All");

# debug output
    print Dumper($data);
}

main();
