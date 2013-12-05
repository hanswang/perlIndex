#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

$| = 1;

sub main
{
    my $data = get("http://www.deakin.edu.au/current-students/courses/allcourses.php?hidType=max&year=2014");

# debug output
    print $data;
}

main();
