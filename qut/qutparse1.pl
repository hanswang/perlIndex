#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    for my $i (1 .. 9) {
        my $file = sprintf '<index-%03d.list', $i;

        warn "processing file: $file ...\t";

        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        #course & link
        my $headline = $dom->find('#content h1')->all_text;

        print $dom->find('.undergraduate-table > tbody > tr')->flatten->map(
            sub{
                $_->at('a')->all_text.
                "\t" .
                $_->at('a')->attr('href').
                "\t" .
                $_->find('td:nth-of-type(3)')->all_text.
                "\t" .
                $_->find('td:nth-of-type(4)')->all_text.
                "\t" .
                $_->find('td:nth-of-type(5)')->all_text.
                "\n"
            }
        )->each;

        print $dom->find('.honours-table > tbody > tr')->flatten->map(
            sub{
                $_->at('a')->all_text.
                "\t" .
                $_->at('a')->attr('href').
                "\t" .
                $_->find('td:nth-of-type(3)')->all_text.
                "\t" .
                $_->find('td:nth-of-type(4)')->all_text.
                "\t" .
                $_->find('td:nth-of-type(5)')->all_text.
                "\n"
            }
        )->each;

        print $dom->find('.postgraduate-table > tbody > tr')->flatten->map(
            sub{
                $_->at('a')->all_text.
                "\t" .
                $_->at('a')->attr('href').
                "\t" .
                $_->find('td:nth-of-type(3)')->all_text.
                "\t" .
                $_->find('td:nth-of-type(4)')->all_text.
                "\t" .
                $_->find('td:nth-of-type(5)')->all_text.
                "\n"
            }
        )->each;

        close ($info);
        warn "Done. $file closed\n";
    }
}

main();
