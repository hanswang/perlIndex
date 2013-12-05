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
    for my $i (1 .. 199) {
        my $file = sprintf '<pgstore/uentry-%03d.html', $i;

        warn "processing file: $file ...\t";
        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        print $i . "\t";
        # admission
        my $admission = '';
        my $start = $dom->find('#two_col_left_holder .contributor_content_div > h2:first-of-type');
        if ($start->flatten->size) {
            while(index($start->all_text, 'Academic Requirements') < 0 && $start->next->flatten->size && defined($start->next->flatten->[0])) {
                #print $start->all_text."\n";
                $start = $start->next;
            }
            if (index($start->all_text, 'Academic Requirements') >= 0) {
                while($start->next->flatten->size && index($start->next->all_text, 'English Language') < 0 && !($start->next->type eq 'h2') && !($start->next->type eq 'h3')) {
                    $admission .= $start->next->all_text;

                    $start = $start->next;
                }
            }
        }
        if (!(trim($admission) eq '')) {
            print $admission;
        } else {
            print "N/A";
        }

        close ($info);
        warn "Done. $file closed\n";
        print "\n";
    }
}

main();
