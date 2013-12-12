#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    for my $i (1 .. 2) {
        my $file = sprintf '<index-%03d.list', $i;

        warn "processing file: $file ...\t";

        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        #course & link
        print $dom->find('#mainContentContainer a')->flatten->map(
            sub{
                if(length($_->attr('href')) > 0) {
                    $_->all_text.
                    "\t" .
                    'http://www.usc.edu.au'.$_->attr('href').
                    "\n"
                }
            }
        )->each;

        close ($info);
        warn "Done. $file closed\n";
    }
}

main();
