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
    my $file = '<initialIndex.html';

    local $/;
    open my $info, $file or die "Can't oepn data";
    my $html = <$info>;

    my $dom = Mojo::DOM->new;

    $dom->parse($html);

    print "study\tlink\tname\n";

    # coursename && link
    print $dom->find('div#content div.accordion h2')->flatten->map(
        sub {
            $_->all_text . "\n" .
            $_->next->find('a')->flatten->map(
                sub {
                    $_->all_text .
                    "\t" .
                    $_->attr('href') .
                    "\n"
                })->join('')
        })->each;
    close ($info);
    print "\n";
    warn "Done. $file closed\n";
}

main();
