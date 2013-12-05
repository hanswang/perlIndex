#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use JSON qw( decode_json );

$| = 1;

sub main
{
    open (DATA, "<adld/adelaideIndex") or die "Can't oepn data";
    while (<DATA>)
    {   
        my $data = $_; 
        chomp($data);

        my @decoded_json = @{decode_json($data)};
# print Dumper @decoded_json;

        print "Program Name\tDegree\tCampus\tDuration\tATAR\tOutline-backup\n";

        foreach my $course (@decoded_json) {
            my $cName = $course->{'title'};
            print $cName . "\t";

            my $degree = $course->{'degree'};
            print $degree . "\t";

            my $campus = $course->{'campus'};
            print $campus . "\t";

            my $duration = $course->{'duration'};
            print $duration . "\t";

            my $atar = $course->{'atar'};
            print $atar . "\t";

            my $outline = $course->{'outline'};
            print $outline . "\n";

        }
    }   

    close (DATA);

}

main();
