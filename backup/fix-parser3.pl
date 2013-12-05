#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    print "Provider\tCampus/Location\tCampus Post Code\tG/P\tApplication Fees\tAcademic Admission Requirement\tAssured Knowledge\tMajor Available\tStudy Area\tBack up Reference\n";

    for my $i (1 .. 474) {
        my $file = sprintf '<store/%03d.html', $i;
        binmode $file, ':encoding(utf8)';

        warn "processing file: $file ...\t";

        print "Australian National University\tActon\t0200\tG\t100\t";
        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # requirement
        my $reqText = '';
        if ($dom->find('div.main div.body__inner h2#admission-requirements')->size) {
            my $startR = $dom->find('div.main div.body__inner h2#admission-requirements');
            while($startR->next->size && !($startR->next->attr('id') eq 'bonus-points') && !($startR->next->attr('id') eq 'indicative-fees') && !($startR->next->attr('id') eq 'program-requirements') && !($startR->next->attr('id') eq 'scholarships') && !($startR->next->attr('id') eq 'prerequisites')) {
                $reqText .= $startR->next->all_text;
                $startR = $startR->next;
            }
        }
        if (!(trim($reqText) eq '')) {
            print $reqText ."\t";
        } else {
            print "N/A\t";
        }

        # assured knowledge
        my $assknow = '';
        if ($dom->find('div.main div.body__inner h3#prerequisites')->size) {
            my $startR = $dom->find('div.main div.body__inner h3#prerequisites');
            while($startR->next->size && !($startR->next->attr('id') eq 'bonus-points') && !($startR->next->attr('id') eq 'indicative-fees') && !($startR->next->attr('id') eq 'program-requirements') && !($startR->next->attr('id') eq 'scholarships')) {
                $assknow .= $startR->next->all_text;
                $startR = $startR->next;
            }
        }
        if (!(trim($assknow) eq '')) {
            print $assknow."\t";
        } else {
            print "N/A\t";
        }

        # major
        my $courseName = $dom->at('div.intro span.intro__degree-title__component')->text;
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
        print $mText."\t".$mText;

        # study area
        my $facultyName = $dom->at('div.intro span.first-owner')->text;
        my @areaArray = ('Engineering', 'Computer Science', 'Science', 'Business', 'Economics', 'Arts', 'Social Sciences', 'Asia and the Pacific', 'International Political', 'Culture', 'History', 'Language', 'Law', 'Medicine', 'Biology', 'Environment', 'Strategic Studies', 'Population Health', 'Arab and Islamic Studies', 'Security', 'Physical', 'Mathematical', 'Archaeology', 'Anthropology');
        foreach my $areaF (@areaArray) {
            if (index($facultyName, $areaF) > 0) {
                print "/ $areaF";
            }
        }
        print "\t";

        print $dom->find('div.main div.body__inner')->all_text;
        close ($info);
        print "\n";
        warn "Done. $file closed\n";
    }
}

main();
