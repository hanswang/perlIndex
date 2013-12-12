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
        my $file = sprintf '<storeit/%03d.html', $i;

        warn "processing file: $file ...\t";

        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        my $fee = '';
        my $ielts = '';
        if ($dom->find('#content h1')->size) {
            if ($dom->find('#costs .cost-box')->size) {
                $fee = $dom->find('#costs .cost-box')->all_text;
            }
            if ($dom->find('#entry-intro .requirement-tables .ielts-table')->size) {
                $ielts = $dom->find('#entry-intro .requirement-tables .ielts-table')->all_text;
            }

        }

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

        close ($info);
        print "\n";
        warn "Done. $file closed\n";
    }
}

main();
