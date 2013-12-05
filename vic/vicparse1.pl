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
    my $file = '<courseIndex.html';

    local $/;
    open my $info, $file or die "Can't oepn data";
    my $html = <$info>;

    my $dom = Mojo::DOM->new;

    $dom->parse($html);

    print "CourseName\tLink\n";

    # coursename && link
    print $dom->find('div#residents li a')->flatten->map(
        sub {
            $_->all_text .
            "\t".
            'http://www.vu.edu.au' .$_->attr('href') .
            "\n";
        }
    )->each;
    close ($info);
    print "\n";
    warn "Done. $file closed\n";
}

main();
