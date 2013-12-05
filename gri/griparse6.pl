#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    for my $i (1 .. 217) {
        my $file = sprintf '<storeDmAtar/%03d.html', $i;

        warn "processing file: $file ...\t";

        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # start
        my $atar = '';
        my $start = $dom->find('a#howDoIApply');
        if ($start->size) {
            my $block = $start->next;
            my $title1 = $block->find('h3:first-of-type');
            while ($title1->next->compact->size && index($title1->all_text, 'application information') < 0) {
                $title1 = $title1->next;
            }
            while ($title1->compact->size && index($title1->all_text, 'application information') >= 0) {
                while($title1->next->compact->size) {
                    if ($title1->next->type eq 'div') {
                        $title1 = $title1->next;
                        my $cutoff = $title1->find('.cutoff');
                        $atar .= $cutoff->all_text;
                        $atar .= "\t";
                        my $desc = $title1->find('.description');
                        my $range = $title1->find('.description .tablerow')->size;
                        if ($range > 3) {
                            $atar .= $desc->find('.tablerow:nth-of-type(2)')->all_text .' / ';
                            $atar .= $desc->find('.tablerow:nth-of-type(3)')->all_text;
                        } else {
                            $atar .= $desc->find('.tablerow:nth-of-type(2)')->all_text;
                        }
                        $title1 = $title1->next;
                        last;
                    } else {
                        $title1 = $title1->next;
                    }
                }
                $atar .= "\t";
            }
        }

        if (trim($atar) eq '') {
            print 'N/A';
        } else {
            print trim($atar);
        }

        close ($info);
        print "\n";
        warn "Done. $file closed\n";
    }
}

main();
