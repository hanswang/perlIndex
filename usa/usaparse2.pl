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
    print "name\tduration\tcampus\tcricos\tfeeanu\tfeetotal\tintake\tielts\tentry\n";

    for my $i (1 .. 593) {
        my $file = '';
        if ($i == 180) {
            $file = sprintf '<store/%03d.html', $i;
        } else {
            $file = sprintf '<intstore/%03d.html', $i;
        }

        warn "processing file: $file ...\t";
        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # coursename
        my $courseName = $dom->find('div#header h1')->text;
        $courseName =~ s/\n[\w| ]+//g;
        print $courseName;
        print "\t";

        # sidebar processing
        my $range = $dom->find('div#column-side .sidebox:first-of-type > p')->flatten->size;

        my $duration = '';
        my $campus = '';
        my $cricos = '';
        my $feeanu = '';
        my $feetotal = '';
        my $intake = '';
        my $ielts = '';
        my $entry = '';

        #print $range;
        for (my $j = 1; $j < $range + 1; $j++) {
            my $pelm = $dom->find('div#column-side .sidebox:first-of-type > p:nth-of-type('.$j.')');
            if ($pelm->all_text eq '') {
                next;
            }

            #print $j ."\n";
            #print $pelm->all_text ."\n";
            if (index($pelm->at('strong')->all_text, 'Duration') >= 0) {
                $duration = $pelm->text;
                next;
            }
            if (index($pelm->at('strong')->all_text, 'Location') >= 0) {
                $campus = $pelm->text;
                next;
            }
            if (index($pelm->at('strong')->all_text, 'CRICOS') >= 0) {
                $cricos = $pelm->text;
                next;
            }
            if (index($pelm->at('strong')->all_text, 'Annual program') >= 0) {
                $feeanu = $pelm->text;
                next;
            }
            if (index($pelm->at('strong')->all_text, 'Total program') >= 0) {
                $feetotal = $pelm->text;
                next;
            }
            if (index($pelm->at('strong')->all_text, 'Start') >= 0) {
                $intake = $pelm->all_text;
                next;
            }
            if (index($pelm->at('strong')->all_text, 'IELTS') >= 0) {
                $ielts = $pelm->all_text;
                next;
            }
        }
        my $extElem = $dom->find('div#column-side .sidebox:first-of-type > strong');
        #print $extElem->all_text;
        if ($extElem->flatten->size) {
            my $extAlink = $extElem->find('ul li:first-of-type a');
            if($extAlink->flatten->size && $extAlink->all_text eq 'Full entry requirements') {
                $entry = 'http://programs.unisa.edu.au'.$extAlink->attr('href');
            }
        }

        if ($duration eq '') {
            print 'N/A';
        } else {
            print $duration;
        }
        print "\t";

        if ($campus eq '') {
            print 'N/A';
        } else {
            print $campus;
        }
        print "\t";

        if ($cricos eq '') {
            print 'N/A';
        } else {
            print $cricos;
        }
        print "\t";

        if ($feeanu eq '') {
            print 'N/A';
        } else {
            print $feeanu;
        }
        print "\t";

        if ($feetotal eq '') {
            print 'N/A';
        } else {
            print $feetotal;
        }
        print "\t";

        if ($intake eq '') {
            print 'N/A';
        } else {
            print $intake;
        }
        print "\t";

        if ($ielts eq '') {
            print 'N/A';
        } else {
            print $ielts;
        }
        print "\t";

        if ($entry eq '') {
            print 'N/A';
        } else {
            print $entry;
        }

        close ($info);
        warn "Done. $file closed\n";
        print "\n";
    }
}

main();
