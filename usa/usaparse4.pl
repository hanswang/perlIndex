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
    for my $i (1 .. 593) {
        my $file = '';
        $file = sprintf '<store/%03d.html', $i;

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

        my $atar = '';

        #print $range;
        for (my $j = 1; $j < $range + 1; $j++) {
            my $pelm = $dom->find('div#column-side .sidebox:first-of-type > p:nth-of-type('.$j.')');
            if ($pelm->all_text eq '') {
                next;
            }

            #print $j ."\n";
            #print $pelm->all_text ."\n";
            if (index($pelm->at('strong')->all_text, 'ATAR') >= 0) {
                $atar = $pelm->text;
                last;
            }
        }

        if ($atar eq '') {
            print 'N/A';
        } else {
            print $atar;
        }

        close ($info);
        warn "Done. $file closed\n";
        print "\n";
    }
}

main();
