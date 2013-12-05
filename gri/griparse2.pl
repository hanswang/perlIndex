#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    print "Duration\tFaculty\tCricos\tFee\n";

    for my $i (1 .. 486) {
        my $file = sprintf '<storeItFee/%03d.html', $i;

        warn "processing file: $file ...\t";

        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # duration
        my $duration = $dom->find('#secondarymenu li.expanded div#duration')->all_text;
        print $duration;
        print "\t";

        # faculty
        my $faculty = $dom->find('#secondarymenu li.expanded div.wrapperforie > p:first-of-type');
        if ($faculty->find('a')->flatten->size > 1) {
            print $faculty->find('a:first-of-type')->all_text . ' / '. $faculty->find('a:nth-of-type(2)')->all_text;
        } elsif ($faculty->find('a')->flatten->size > 0) {
            print $faculty->find('a')->all_text;
        } else {
            print $faculty->all_text;
        }
        print "\t";

        # cricos
        my $cricos = $dom->find('#secondarymenu li.expanded div.wrapperforie > p:nth-last-of-type(1)')->all_text;
        if (index($cricos, 'CRICOS') >= 0) {
            print $cricos;
        } else {
            print 'N/A';
        }
        print "\t";

        # fee
        if ($dom->find('#feesTable tr')->size) {
            my $fee = $dom->find('#feesTable tr:first-of-type td.feepereftsl')->all_text;
            print $fee;
        } else {
            print 'N/A';
        }

        close ($info);
        print "\n";
        warn "Done. $file closed\n";
    }
}

main();
