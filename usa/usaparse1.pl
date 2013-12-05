#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    for my $i (1 .. 30) {
        my $file = sprintf '<indexList/%03d.html', $i;

        warn "processing file: $file ...\t";

        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        print $dom->find('#content table tr > td:nth-of-type(2) > a')->flatten->map(
            sub{
                $_->attr('href') .
                "\n"
            }
        )->each;
        close ($info);
        warn "Done. $file closed\n";
    }
}

main();
