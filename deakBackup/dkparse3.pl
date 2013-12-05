#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    print "Cousename\tFaculty\n";

    for my $i (1 .. 458) {
        my $file = sprintf '<store/lc-%03d.html', $i;

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
            print "NA\n";
            close ($info);
            warn "NOT found here. $file closed\n";
            next;
        }

        my $faculty = '';

        my $range = $dom->find('div#wmt_content table.course_summary > tr')->flatten->size;
        for (my $i = 1; $i < $range - 1; $i++) {
            if (index($dom->find('div#wmt_content table.course_summary tr:nth-of-type('.$i.') th')->all_text, 'Faculty contacts') >= 0) {
                $faculty = $dom->find('div#wmt_content table.course_summary tr:nth-of-type('.$i.') td')->all_text;
            }
        }

        if (trim($faculty) eq '') {
            print 'N/A';
        } else {
            print $faculty;
        }

        close ($info);
        print "\n";
        warn "Done. $file closed\n";
    }
}

main();
