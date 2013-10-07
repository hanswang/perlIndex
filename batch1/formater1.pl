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
            print $course->{'ProgramName'}
                . "\t" . 'http://programsandcourses.anu.edu.au/2014/program/'.$course->{'AcademicPlanCode'}
                . "\t" . $course->{'CareerText'}
                . "\t" . $course->{'AcademicPlanCode'}
                . "\t" . $course->{'AtarText'}
                . "\t" . $course->{'Duration'}
                . "\t" . (($course->{'StudyAsText'} eq 'Single')? 'Y' : 'N')
                . "\n";
        }
    }   

    close (DATA);

}

main();
