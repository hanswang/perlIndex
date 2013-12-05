#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    print "Duration\tCampus\tFullname\n";

    for my $i (1 .. 681) {
        my $file = sprintf '<store/%03d.html', $i;

        warn "processing file: $file ...\t";

        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        my $label = $dom->find('div.summary p:nth-of-type(5) strong')->text;
        if (trim($label) eq 'Typical Duration:') {
            my $duration = $dom->find('div.summary p:nth-of-type(5)')->text(0);
            $duration =~ s "^.""g;
            print trim($duration);
        } else {
            print "N/A";
        }
        print "\t";

        my $clabel = $dom->find('div.summary p:nth-of-type(3) strong')->text;
        if (trim($clabel) eq 'Campus:') {
            my $campus = $dom->find('div.summary p:nth-of-type(3)')->text(0);
            $campus =~ s "^.""g;
            print trim($campus);
        } else {
            print "N/A";
        }
        print "\t";

        my $name = '';
        for my $j (6 .. 20) {
            if ($dom->find('div.summary p:nth-of-type('.$j.') strong')->size) {
                my $nlabel = $dom->find('div.summary p:nth-of-type('.$j.') strong')->text;
                if (trim($nlabel) eq 'Award(s):') {
                    $j += 1;
                    my $startE = $dom->find('div.summary p:nth-of-type('.($j).')');
                    $name = $startE->text;
                    my $nextE = $dom->find('div.summary p:nth-of-type('.($j+1).')');
                    while( $nextE->size && !($nextE->attr('class') eq 'smalltext')) {
                        $name .= ' / '.$nextE->text;
                        $j += 1;
                        $nextE = $dom->find('div.summary p:nth-of-type('.($j+1).')');
                    }
                }
            } else {
                last;
            }
        }

        if ($name eq '') {
            print "N/A";
        } else {
            print trim($name);
        }

        print "\n";
        close ($info);
        warn "Done. $file closed\n";
    }
}

main();
