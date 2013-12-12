#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    for my $i (1 .. 375) {
        my $file = sprintf '<store/%03d.html', $i;

        warn "processing file: $file ...\t";

        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # coursename
        my $coursename = $dom->find('#content h1')->all_text;
        $coursename =~ s/\n[\w| ]+//g;
        print $coursename . "\t";

        my $duration = '';
        my $faculty = '';
        my $cricos = '';

        my $atar = '';
        my $assured = '';

        my $range = $dom->find('#overview table.overview-table > tr')->size;
        if ($range) {
            for (my $j = 1; $j < $range + 1; $j++) {
                my $label = $dom->find('.overview-table > tr:nth-of-type('.$j.') td:first-of-type')->all_text;
                if (index($label, 'duration') >= 0) {
                    $duration = $dom->find('.overview-table > tr:nth-of-type('.$j.') td:nth-of-type(2)')->all_text;
                    next;
                }
                if (index($label, 'CRICOS') >= 0) {
                    $cricos = $dom->find('.overview-table > tr:nth-of-type('.$j.') td:nth-of-type(2)')->all_text;
                    next;
                }
                if (index($label, 'Faculty') >= 0) {
                    $faculty = $dom->find('.overview-table > tr:nth-of-type('.$j.') td:nth-of-type(2)')->all_text;
                    next;
                }
            }
        }

        if ($dom->find('#entry-dom .cut-offs')->size) {
            if ($dom->find('#entry-dom .cut-offs .op')->size) {
                if ($dom->find('#entry-dom .cut-offs .op > ul')->size) {
                    $atar .= 'OP: ' .$dom->find('#entry-dom .cut-offs .op > ul')->all_text;
                } else {
                    $atar .= 'OP: ' .$dom->find('#entry-dom .cut-offs .op > h4')->text;
                }
            }
            if ($dom->find('#entry-dom .cut-offs .rank')->size) {
                if ($dom->find('#entry-dom .cut-offs .op > ul')->size) {
                    $atar .= ' / Rank: ' .$dom->find('#entry-dom .cut-offs .rank > ul')->all_text;
                } else {
                    $atar .= ' / Rank: ' .$dom->find('#entry-dom .cut-offs .rank > h4')->text;
                }
            }
        }

        if ($dom->find('#assumed-knowledge')->size) {
            $assured = $dom->find('#assumed-knowledge')->all_text;
        }

        if (trim($duration) eq '') {
            print 'N/A';
        } else {
            print $duration;
        }
        print "\t";

        if (trim($faculty) eq '') {
            print 'N/A';
        } else {
            print $faculty;
        }
        print "\t";

        if (trim($cricos) eq '') {
            print 'N/A';
        } else {
            print $cricos;
        }
        print "\t";

        if (trim($atar) eq '') {
            print 'N/A';
        } else {
            print $atar;
        }
        print "\t";

        if (trim($assured) eq '') {
            print 'N/A';
        } else {
            print $assured;
        }

        close ($info);
        print "\n";
        warn "Done. $file closed\n";
    }
}

main();
