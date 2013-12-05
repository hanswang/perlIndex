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
    print "assured\tadmission\n";

    for my $i (1 .. 593) {
        my $file = '';
        $file = sprintf '<addstore/%03d.html', $i;

        warn "processing file: $file ...\t";
        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;
        if (trim($html) eq '') {
            print "N/A\tN/A\n";
            close ($info);
            warn "Done. $file closed\n";
            next;
        }

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # assured & admission
        my $assured = '';
        my $admission = '';

        my $start = $dom->find('div#content > h3:first-of-type');
        if ($start->flatten->size) {
            #print $start->all_text;
            while(index($start->all_text, 'Entry requirements') < 0 && $start->next->flatten->size) {
                $start = $start->next;
            }
            #print $start->all_text;
            if (index($start->all_text, 'Entry requirements') >= 0) {
                #print $start->next->all_text. "\n";
                #print $start->next->type. "\n";
                while($start->next->flatten->size && index($start->next->all_text, 'English language') < 0 && !($start->next->type eq 'h3')) {
                    #print $start->next->all_text. "\n";
                    #print $start->next->type. "\n";
                    if (index($start->next->all_text, 'Assumed') >= 0) {
                        $assured = $start->next->all_text;
                    } else {
                        $admission .= $start->next->all_text;
                    }

                    $start = $start->next;
                }
            }
        }

        if ($assured eq '') {
            print 'N/A';
        } else {
            print $assured;
        }
        print "\t";

        if ($admission eq '') {
            print 'N/A';
        } else {
            print $admission;
        }

        close ($info);
        warn "Done. $file closed\n";
        print "\n";
    }
}

main();
