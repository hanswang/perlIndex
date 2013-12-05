#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    print "admission\n";

    for my $i (1 .. 486) {
        my $file = sprintf '<storeItApply/%03d.html', $i;

        warn "processing file: $file ...\t";

        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # start
        my $ielts = '';
        my $start = $dom->find('a#canIApply');
        if ($start->size) {
            my $block = $start->next;
            my $title1 = $block->find('h3:first-of-type');
            while ($title1->next->compact->size && index($title1->all_text, 'anguage requirements') < 0) {
                $title1 = $title1->next;
            }
            if (index($title1->all_text, 'anguage requirements') >= 0) {
                while($title1->next->compact->size) {
                    if ($title1->next->type eq 'ul') {
                        $title1 = $title1->next;
                        my $refielts = $title1->find('li')->map(sub{
                                return $_->all_text;
                            })->join(' / ')->trim;
                        $ielts = $$refielts;
                        $ielts =~ s/\n//g;
                        last;
                    } else {
                        $title1 = $title1->next;
                    }
                }
            }
        }

        if ($ielts eq '') {
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
