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

    for my $i (218 .. 486) {
        my $file = sprintf '<storeItApply/%03d.html', $i;

        warn "processing file: $file ...\t";

        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # start
        my $admin = '';
        my $start = $dom->find('a#canIApply');
        if ($start->size) {
            my $block = $start->next;
            my $title1 = $block->find('h3:first-of-type');
            if (index($title1->all_text, 'Admission requirements') >= 0) {
                while($title1->next->compact->size) {
                    if (index($title1->next->all_text, 'anguage requirements') >= 0 || $title1->next->type eq 'h4') {
                        last;
                    } else {
                        $admin .= $title1->next->all_text;
                        $title1 = $title1->next;
                    }
                }
            }
        }

        if ($admin eq '') {
            print 'N/A';
        } else {
            print $admin;
        }

        close ($info);
        print "\n";
        warn "Done. $file closed\n";
    }
}

main();
