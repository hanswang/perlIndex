#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use Mojo::Collection;
use String::Util 'trim';

$| = 1;

sub main
{
    print "CourseName\tFaculty\tCricos\tinTake\tATAR\tIB\tTuition\tIELTS\tMajor\tAssured Knowledge\tAcademic Admission Requirement\n";

    for my $i (1 .. 484) {
        my $file = sprintf '<store/%03d.html', $i;

        warn "processing file: $file ...\t";

        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # coursename
        my $coursename = $dom->find('div.detail-glance h2')->text;
        print $coursename ."\t";

        # faculty
        my $faculty = '';
        if (($dom->find('div#page-content a#rules')->size) && ($dom->find('div#page-content a#rules')->siblings('.detail-data-content a')->flatten->size)) {
            $faculty = $dom->find('div#page-content a#rules')->siblings('.detail-data-content a')->all_text;
        } else {
            $faculty = 'N/A';
        }
        print $faculty ."\t";

        my $range = $dom->find('div#international_applicant table.ui-table:first-of-type tr')->size;
        my $cricos = 'N/A';
        for (my $i = 1; $i < $range; $i++) {
            if ($dom->find('div#international_applicant table.ui-table:first-of-type tr:nth-of-type('.$i.') td:nth-of-type(1)')->all_text eq 'CRICOS') {
                # cricos
                $cricos = $dom->find('div#international_applicant table.ui-table:first-of-type tr:nth-of-type('.$i.') td:nth-of-type(2)')->text;
            }
        }
        print $cricos ."\t";

        my $intake = 'N/A';
        for (my $i = 1; $i < $range; $i++) {
            if ($dom->find('div#international_applicant table.ui-table:first-of-type tr:nth-of-type('.$i.') td:nth-of-type(1)')->all_text eq 'Mid-year entry?') {
                # intake
                $intake = $dom->find('div#international_applicant table.ui-table:first-of-type tr:nth-of-type('.$i.') td:nth-of-type(2)')->text;
            }
        }
        print $intake ."\t";

        my $tuition = 'N/A';
        for (my $i = 1; $i < $range; $i++) {
            if ($dom->find('div#international_applicant table.ui-table:first-of-type tr:nth-of-type('.$i.') td:nth-of-type(1)')->all_text eq 'Annual tuition fees') {
                # tuition
                $tuition = $dom->find('div#international_applicant table.ui-table:first-of-type tr:nth-of-type('.$i.') td:nth-of-type(2)')->text;
            }
        }
        print substr($tuition, index($tuition, '$')) ."\t";

        my $range2 = $dom->find('div#domestic_applicant table.ui-table:first-of-type tr')->size;
        my $atar = 'N/A';
        for (my $j = 1; $j < $range2; $j++) {
            if ($dom->find('div#domestic_applicant table.ui-table:first-of-type tr:nth-of-type('.$j.') td:nth-of-type(1)')->all_text eq '2013 CSP ATAR') {
                # atar
                $atar = $dom->find('div#domestic_applicant table.ui-table:first-of-type tr:nth-of-type('.$j.') td:nth-of-type(2)')->text;
            }
        }
        print $atar ."\t";

        my $ib = 'N/A';
        for (my $j = 1; $j < $range2; $j++) {
            if ($dom->find('div#domestic_applicant table.ui-table:first-of-type tr:nth-of-type('.$j.') td:nth-of-type(1)')->all_text eq '2013 CSP IB') {
                $ib = $dom->find('div#domestic_applicant table.ui-table:first-of-type tr:nth-of-type('.$j.') td:nth-of-type(2)')->text;
            }
        }
        print $ib ."\t";

        # ielts
        my $range3 = $dom->find('div#international_applicant table.ui-table:nth-of-type(2) tr')->size;
        my $ietxt = 'N/A';
        for (my $i = 1; $i < $range3; $i++) {
            if (index($dom->find('div#international_applicant table.ui-table:nth-of-type(2) tr:nth-of-type('.$i.') td:nth-of-type(1)')->all_text, 'IELTS') >= 0) {
                # ielts
                my $ielts = $dom->find('div#international_applicant table.ui-table:nth-of-type(2) tr:nth-of-type('.$i.') td:nth-of-type(2)');
                my $o = $ielts->find('div:first-of-type')->text;
                my $r = $ielts->find('div:nth-of-type(2)')->text;
                my $l = $ielts->find('div:nth-of-type(3)')->text;
                my $s = $ielts->find('div:nth-of-type(4)')->text;
                my $w = $ielts->find('div:nth-of-type(5)')->text;
                $ietxt = 'overall: '.$o.', r: '.$r.', l: '.$l.', s: '.$s.', w: '.$w."\t";
            }
        }
        print $ietxt ."\t";

        close ($info);
        print "\n";
        warn "Done. $file closed\n";
    }
}

main();
