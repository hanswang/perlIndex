#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    my $file = 'programeIndex.xml';

    local $/;
    open my $info, $file or die "Can't oepn data";
    my $html = <$info>;

    my $dom = Mojo::DOM->new;
    $dom->parse($html);

    print "coursename\tlink\tcampus\topenInternational\tdegree\tduration\tcricos\tschool\n";

    print $dom->find('School')->map(
        sub{
            return $_->find('Program')->flatten->map(
                sub{
                    my $name = $_->find('Award')->all_text;
                    $name =~ s/\n|\r/ /g;
                    
                    my $link = 'http://programfinder.federation.edu.au/ProgramFinder/displayProgram.jsp?ID=' . $_->attr('id');

                    my $inter = $_->find('ActiveInternational')->all_text;

                    my $campus = 'N/A';
                    if ($_->find('Campuses')->size) {
                        $campus = $_->find('Campuses')->all_text;
                    }

                    my $degree = $_->find('CourseType')->all_text;

                    my $duration = $_->find('Length')->all_text;
                    $duration =~ s/\n|\r/ /g;
                    $duration =~ s/&lt;[\/|\w|;|=|:|-| |\.]*&gt;/ /g;
                    $duration =~ s/&amp;amp;/ /g;
                    $duration =~ s/&amp;bull;/ /g;
                    $duration =~ s/&quot;/ /g;

                    my $cricos = $_->find('CourseCode')->all_text;

                    my $school = $_->parent->attr('id');

                    return $name ."\t". $link ."\t". $campus ."\t". $inter ."\t". $degree ."\t". $duration ."\t". $cricos ."\t". $school ."\n";
                }
            )->each
        }
    )->each;
    print "\n";

    close ($info);
}

main();
