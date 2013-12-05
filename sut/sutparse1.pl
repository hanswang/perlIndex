#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use Mojo::Collection;
use String::Util 'trim';

$| = 1;

sub main
{
    my $file = '<sutCopy.html';

    local $/;
    open my $info, $file or die "Can't oepn data";
    my $html = <$info>;

    my $dom = Mojo::DOM->new;

    $dom->parse($html);

    print "name\tlink\tmode\tintake\tcampus\n";

    # coursename && link
    print $dom->find('tr.csrow')->flatten->map(
        sub {
            $_->children('td')->first->children('a')->first->all_text .
            "\t" .
            $_->children('td')->first->children('a')->first->attr('href') .
            "\t" .
            $_->children('td')->[2]->all_text .
            "\t" .
            $_->at('table.summary')->find('tr')->flatten->map(sub{
                if (index($_->find('td:first-of-type')->all_text, 'modes') >= 0) {
                    return $_->find('td:nth-of-type(2)')->all_text;
                } elsif (index($_->find('td:first-of-type')->all_text, 'Intake') >= 0) {
                    return $_->find('td:nth-of-type(2)')->all_text;
                } else {
                    return 'N/A';
                }
            })->join("\t") .
            "\n"
        })->each;

    close ($info);
    warn "Done. $file closed\n";
}

main();
