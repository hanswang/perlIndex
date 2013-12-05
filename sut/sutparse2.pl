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

    for my $i (1 .. 583) {
        my $file = sprintf '<store/%03d.html', $i;

        warn "processing file: $file ...\t";
        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # coursename
        my $courseName = '';
        if ($dom->find('#content-col-sidebar h1')->size) {
            $courseName = $dom->find('#content-col-sidebar h1')->all_text;
        } else {
            close ($info);
            warn "Skipped . $file closed\n";
            print "$i file no content";
            print "\n";
            next;
        }
        $courseName =~ s/\n[\w| ]+//g;
        print $courseName ."\t";

        # duration
        my $duration = '';
        if ($dom->find('#summary > tbody > tr:nth-of-type(1) td:nth-of-type(2)')->size) {
            $duration = $dom->find('#summary > tbody > tr:nth-of-type(1) td:nth-of-type(2)')->all_text;
        }

        # cricos
        my $cricos = '';
        if ($dom->find('#summary tr:nth-of-type(4) td:nth-of-type(2)')->size) {
            $cricos = $dom->find('#summary tr:nth-of-type(4) td:nth-of-type(2)')->all_text;
        }

        # fee
        my $fee = '';
        if ($dom->find('#summary tr:nth-of-type(5) td:nth-of-type(2)')->size) {
            $fee = $dom->find('#summary tr:nth-of-type(5) td:nth-of-type(2)')->all_text;
        }

        #ielts
        my $ielts = '';
        if ($dom->find('#english')->size) {
            my $ielts_loc = $dom->at('#english');
            if (defined ($ielts_loc->next->next)) {
                $ielts = $ielts_loc->next->next->all_text;
            }
        }

        #admission
        my $admission = '';
        if ($dom->find('#prerequisites')->size) {
            my $admission_loc = $dom->at('#prerequisites');
            if (defined ($admission_loc->next->next)) {
                $admission = $admission_loc->next->next->all_text;
            }
        }

        #major
        my $major = '';
        if ($dom->find('#specialisations')->size) {
            my $major_loc = $dom->at('#specialisations')->parent;
            $major = $major_loc->find('a')->flatten->map(
                sub{
                    if (index($_->all_text, 'Major') >= 0) {
                        return $_->all_text .' / ';
                    }
                }
            )->join('');
        }

        if (!(trim($duration) eq '')) {
            print $duration;
        } else {
            print "N/A";
        }
        print "\t";

        if (!(trim($cricos) eq '')) {
            print $cricos;
        } else {
            print "N/A";
        }
        print "\t";

        if (!(trim($fee) eq '')) {
            print $fee;
        } else {
            print "N/A";
        }
        print "\t";

        if (!(trim($ielts) eq '')) {
            print $ielts;
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

        if (!(trim($major) eq '')) {
            print $major;
        } else {
            print "N/A";
        }

        close ($info);
        warn "Done. $file closed\n";
        print "\n";
    }
}

main();
