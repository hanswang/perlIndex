#!/usr/bin/perl

use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

$| = 1;

sub main
{
    my $data = get("http://programsandcourses.anu.edu.au/data/MajorSearch/GetMajors?submit=Search&url=&querytext=&stype=ANU+Web&Source=SearchResults&PageIndex=0&MaxPageSize=200&PageSize=200&SearchText=&Careers%5B0%5D=&Careers%5B1%5D=&Careers%5B2%5D=&Careers%5B3%5D=&FilterByPrograms=false&FilterByMajors=true&FilterByMinors=False&FilterBySpecialisations=False&FilterByCourses=False&DegreeIdentifiers%5B0%5D=&DegreeIdentifiers%5B1%5D=&DegreeIdentifiers%5B2%5D=&Sessions%5B0%5D=&Sessions%5B1%5D=&Sessions%5B2%5D=&Sessions%5B3%5D=&Sessions%5B4%5D=&Sessions%5B5%5D=&SelectedYear=2014&AtarMin=70.00&AtarMax=100.00&CollegeName=All+Colleges");

# debug output
    print Dumper($data);
}

main();
