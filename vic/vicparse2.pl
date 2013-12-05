#!/usr/bin/perl

use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;
use Mojo::DOM;
use Mojo::Collection;
use String::Util 'trim';

$| = 1;

sub main
{
    print "name\tlocation\tfulltime\tfaculty\tduration\tmajor\tstudy\tassured\tadmission\t";

    print "allowInternational\tintake\tcricos\tfees\n";

    for my $i (1 .. 457) {
        my $file = sprintf '<store/%03d.html', $i;

        warn "processing file: $file ...\t";
        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # coursename
        my $courseName = $dom->find('div#main-content h1')->all_text;
        $courseName =~ s/\n[\w| ]+//g;
        print $courseName ."\t";

        # location
        my $location = '';
        if ($dom->find('#course-essentials li.location')->size) {
            $location = $dom->find('#course-essentials li.location div:nth-of-type(2)')->all_text;
        }

        # otherlocations
        my $otherlocations = '';
        if ($dom->find('#course-essentials li.other-locations')->size) {
            $otherlocations = $dom->find('#course-essentials li.other-locations div:nth-of-type(2)')->all_text;
        }
        my $locsum = '';
        if (!(trim($location) eq '')) {
            $locsum = $location;
            if (!(trim($otherlocations) eq '')) {
                $locsum .= ' / '. $otherlocations;
            }
        } else {
            if (!(trim($otherlocations) eq '')) {
                $locsum = $otherlocations;
            }
        }
        if (!(trim($locsum) eq '')) {
            print $locsum;
        } else {
            print "N/A";
        }
        print "\t";

        # studymode
        my $studymode = '';
        if ($dom->find('#course-essentials li.study-mode')->size) {
            $studymode = $dom->find('#course-essentials li.study-mode div:nth-of-type(2)')->all_text;
        }
        if (!(trim($studymode) eq '')) {
            print $studymode;
        } else {
            print "N/A";
        }
        print "\t";

        # college
        my $college = '';
        if ($dom->find('#course-essentials li.college')->size) {
            $college = $dom->find('#course-essentials li.college div:nth-of-type(2)')->all_text;
        }
        if (!(trim($college) eq '')) {
            print $college;
        } else {
            print "N/A";
        }
        print "\t";

        # duration
        my $duration = '';
        if ($dom->find('#course-essentials li.duration')->size) {
            $duration = $dom->find('#course-essentials li.duration div:nth-of-type(2)')->all_text;
        }
        if (!(trim($duration) eq '')) {
            print $duration;
        } else {
            print "N/A";
        }
        print "\t";

        # major && study
        my $mText = '';
        my $f1text = '';
        my $f2text = '';
        if (index($courseName, ' of ') > 0) {
            $mText = substr($courseName, index($courseName, ' of ') + 4);
        } elsif (index($courseName, ' in ') > 0) {
            $mText = substr($courseName, index($courseName, ' in ') + 4);
        } else {
            $mText = 'Research';
        }
        if (index($mText, 'Bachelor of ') > 0) {
            $f1text = substr($mText, 0, index($mText, 'Bachelor of '));
            $f2text = substr($mText, index($mText, 'Bachelor of ') + 12);
            $mText = $f1text . $f2text;
        }
        if (index($mText, 'Master of ') > 0) {
            $f1text = substr($mText, 0, index($mText, 'Master of '));
            $f2text = substr($mText, index($mText, 'Master of ') + 10);
            $mText = $f1text . $f2text;
        }
        if (index($mText, ' (Honours)') > 0) {
            $f1text = substr($mText, 0, index($mText, ' (Honours)'));
            $f2text = substr($mText, index($mText, ' (Honours)') + 10);
            $mText = $f1text . $f2text;
        }
        if (index($mText, 'Honours ') > 0) {
            $f1text = substr($mText, 0, index($mText, 'Honours '));
            $f2text = substr($mText, index($mText, 'Honours ') + 8);
            $mText = $f1text . $f2text;
        }

        # major & study
        if ($dom->find('#description ul > li > a')->size) {
            print $dom->find('#description ul > li > a')->flatten->map( sub{ return $_->all_text . " / "; })->each;
            print "\t";
            print $dom->find('#description ul > li > a')->flatten->map( sub{ return $_->all_text . " / "; })->each;
            print " / ". $mText;
        } else {
            print $mText ."\t". $mText;
        }
        print "\t";

        # assured & admission
        my $assured = '';
        my $admission = '';
        my $y12 = '';
        my $interAdmin = '';
        my $matureAdmin = '';
        if ($dom->find('#admission-information > ul')->size) {
            my $range = $dom->find('#admission-information > ul > li')->size;
            for (my $j = 1; $j <= $range; $j++) {
                if (index($dom->find('#admission-information > ul > li:nth-of-type('.$j.')')->all_text, 'Year 12:') >= 0) {
                    $y12 = $dom->find('#admission-information > ul > li:nth-of-type('.$j.')')->all_text;
                }
                if (index($dom->find('#admission-information > ul > li:nth-of-type('.$j.')')->all_text, 'International:') >= 0) {
                    $interAdmin = $dom->find('#admission-information > ul > li:nth-of-type('.$j.')')->all_text;
                }
                if (index($dom->find('#admission-information > ul > li:nth-of-type('.$j.')')->all_text, 'Mature:') >= 0) {
                    $matureAdmin = $dom->find('#admission-information > ul > li:nth-of-type('.$j.')')->all_text;
                }
            }
        }
        if (index($courseName, 'Bachelor') >= 0) {
            $assured = $y12;
            $admission = $y12 .' '. $interAdmin .' '. $matureAdmin;
        } else {
            $admission = $interAdmin .' '. $matureAdmin;
        }
        if (!(trim($assured) eq '')) {
            print $assured;
        } else {
            print "N/A";
        }
        print "\t";
        if (!(trim($admission) eq '')) {
            print $admission;
        } else {
            print "N/A";
        }
        print "\t";

        if ($dom->find('div#main-content .nav.nav-tabs')->size) {
            print "Y\t";

            my $fileit = sprintf '<store/%03d-it.html', $i;
            warn "processing file: $fileit ...\t";

            local $/;
            open my $infoit, $fileit or die "Can't oepn data";
            my $htmlit = <$infoit>;
            my $domit = Mojo::DOM->new;

            $domit->parse($htmlit);

            # intake
            my $intake = '';
            if ($domit->find('#course-essentials li.intake')->size) {
                $intake = $domit->find('#course-essentials li.intake div:nth-of-type(2)')->all_text;
            }
            if (!(trim($intake) eq '')) {
                print $intake;
            } else {
                print "N/A";
            }
            print "\t";

            # cricos
            my $cricos = '';
            if ($domit->find('#course-essentials li.cricos')->size) {
                $cricos = $domit->find('#course-essentials li.cricos div:nth-of-type(2)')->all_text;
            }
            if (!(trim($cricos) eq '')) {
                print $cricos;
            } else {
                print "N/A";
            }
            print "\t";

            # fees
            my $fees = '';
            if ($domit->find('#course-essentials li.fees')->size) {
                $fees = $domit->find('#course-essentials li.fees div:nth-of-type(2)')->all_text;
            }
            if (!(trim($fees) eq '')) {
                print $fees;
            } else {
                print "N/A";
            }
            close ($infoit);
            warn "Done. $fileit closed\t";

        } else {
            print "N/A\tN/A\tN/A\tN/A";
        }

        close ($info);
        warn "Done. $file closed\n";
        print "\n";
    }
}

main();
