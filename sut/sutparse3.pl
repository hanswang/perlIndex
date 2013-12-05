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
        my $file = sprintf '<store/lc-%03d.html', $i;

        warn "processing file: $file ...\t";
        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # coursename
        my $courseName = $dom->find('#content-col-sidebar h1')->all_text;
        $courseName =~ s/\n[\w| ]+//g;
        print $courseName ."\t";

        # atar
        my $atar = '';
        if ($dom->find('#atar-info .atar-number')->size) {
            $atar = $dom->find('#atar-info .atar-number')->all_text;
        }

        #assured
        my $assured = '';
        if ($dom->find('#entryrequirements')->size) {
            my $assured_loc = $dom->at('#entryrequirements')->parent;
            $assured = $assured_loc->children->flatten->map(
                sub{
                    if (index($_->all_text, 'For 2014 entry') == 0) {
                        return $_->all_text;
                    }
                }
            )->join('');
        }

        if (!(trim($atar) eq '')) {
            print $atar;
        } else {
            print "N/A";
        }
        print "\t";

        if (!(trim($assured) eq '')) {
            print $assured;
        } else {
            print "N/A";
        }

        close ($info);
        warn "Done. $file closed\n";
        print "\n";
    }
}

main();
