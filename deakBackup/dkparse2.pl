#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    print "Cousename\tcricos\tDuration\tCampus\tIntake\tAnnual Fees\tielts\n";

    for my $i (1 .. 458) {
        my $file = sprintf '<store/it-%03d.html', $i;

        warn "processing file: $file ...\t";

        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # name
        my $coursename = $dom->find('div#wmt_content h1')->all_text;
        print $coursename;
        print "\t";

        if (index($coursename, 'Not found') >= 0) {
            print "NA\tNA\tNA\tNA\tNA\tNA\n";
            close ($info);
            warn "NOT found here. $file closed\n";
            next;
        }

        my $cricos = '';
        my $length = '';
        my $campus = '';
        my $intake = '';
        my $fee = '';
        my $ielts = '';

        my $range = $dom->find('div#wmt_content table.course_summary tr')->flatten->size;

        for (my $i = 1; $i < $range; $i++) {
            if (index($dom->find('div#wmt_content table.course_summary tr:nth-of-type('.$i.') th')->all_text, 'CRICOS') >= 0) {
                $cricos = $dom->find('div#wmt_content table.course_summary tr:nth-of-type('.$i.') td')->all_text;
            }
            if (index($dom->find('div#wmt_content table.course_summary tr:nth-of-type('.$i.') th')->all_text, 'Length') >= 0) {
                $length = $dom->find('div#wmt_content table.course_summary tr:nth-of-type('.$i.') td')->all_text;
            }
            if (index($dom->find('div#wmt_content table.course_summary tr:nth-of-type('.$i.') th')->all_text, 'Campus') >= 0) {
                $campus = $dom->find('div#wmt_content table.course_summary tr:nth-of-type('.$i.') td')->all_text;
            }
            if (index($dom->find('div#wmt_content table.course_summary tr:nth-of-type('.$i.') th')->all_text, 'available intake') >= 0) {
                $intake = $dom->find('div#wmt_content table.course_summary tr:nth-of-type('.$i.') td')->all_text;
            }
            if (index($dom->find('div#wmt_content table.course_summary tr:nth-of-type('.$i.') th')->all_text, 'annual fee') >= 0) {
                $fee = $dom->find('div#wmt_content table.course_summary tr:nth-of-type('.$i.') td')->all_text;
            }
            if (index($dom->find('div#wmt_content table.course_summary tr:nth-of-type('.$i.') th')->all_text, 'IELTS') >= 0) {
                $ielts = $dom->find('div#wmt_content table.course_summary tr:nth-of-type('.$i.') td')->all_text;
            }
        }

        if (trim($cricos) eq '') {
            print 'N/A';
        } else {
            print $cricos;
        }
        print "\t";

        if (trim($length) eq '') {
            print 'N/A';
        } else {
            print $length;
        }
        print "\t";

        if (trim($campus) eq '') {
            print 'N/A';
        } else {
            print $campus;
        }
        print "\t";

        if (trim($intake) eq '') {
            print 'N/A';
        } else {
            print $intake;
        }
        print "\t";

        if (trim($fee) eq '') {
            print 'N/A';
        } else {
            print $fee;
        }
        print "\t";

        if (trim($ielts) eq '') {
            print 'N/A';
        } else {
            print $ielts;
        }
        print "\t";

        close ($info);
        print "\n";
        warn "Done. $file closed\n";
    }
}

main();
