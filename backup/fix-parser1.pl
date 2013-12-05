#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use JSON qw( decode_json );

$| = 1;

sub main
{
    open (DATA, "<courseList.json") or die "Can't oepn data";
    while (<DATA>)
    {   
        my $data = $_; 
        chomp($data);

        my $decoded_json = decode_json($data);
        # print Dumper $decoded_json;

        my @courses = @{$decoded_json->{'Items'}};

        print "Program Name\tLink\tDegree\tCode\tATAR\tYears\tPart-Time\n";

        foreach my $course (@courses) {
            my $cName = $course->{'ProgramName'};
            print $cName . "\t" . 'http://programsandcourses.anu.edu.au/2014/program/'.$course->{'AcademicPlanCode'} ."\t";
            my $degree = $course->{'CareerText'};
            if ($degree eq 'Undergraduate') {
                if (index($cName, 'Associate Degree') != -1) {
                    print 'Associate Degree';
                } elsif (index($cName, 'Bachelor') != -1) {
                    my $tmp_cname = substr($cName, index($cName, 'Bachelor') + 8);
                    if (index($tmp_cname, 'Bachelor') != -1) {
                        if (index($cName, 'Honours') != -1) {
                            print 'Double Bachelor (Honours)';
                        } else {
                            print 'Double Bachelor';
                        }
                    } elsif (index($cName, 'Honours') != -1) {
                        print 'Bachelor (Honours)';
                    } else {
                        print 'Bachelor';
                    }
                } else {
                    print 'Diploma';
                }
            } elsif ($degree eq 'Graduate') {
                if (index($cName, 'Graduate Certificate') != -1) {
                    print 'Graduate Certificate';
                } elsif (index($cName, 'Graduate Diploma') != -1) {
                    print 'Graduate Diploma';
                } elsif (index($cName, 'Master') != -1) {
                    if (index($cName, '/') != -1) {
                        print 'Double Master';
                    } else {
                        print 'Master';
                    }
                } elsif (index($cName, 'Doctor') != -1) {
                    print 'Doctor';
                } else {
                    print 'Graduate Certificate';
                }
            } elsif ($degree eq 'Research') {
                if (index($cName, 'Doctor') != -1) {
                    print 'Doctor';
                } else {
                    print 'Master';
                }
            } else {
                print $degree;
            }
            print "\t";

            print $course->{'AcademicPlanCode'}
                . "\t" . $course->{'AtarText'}
                . "\t" . $course->{'Duration'} * 12
                . "\t" . (($course->{'StudyAsText'} eq 'Single')? 'Y' : 'N')
                . "\n";
        }
    }   

    close (DATA);

}

main();
