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
    my $file = '<bod_pg_index.org';

    local $/;
    open my $info, $file or die "Can't oepn data";
    my $html = <$info>;

    my $dom = Mojo::DOM->new;

    $dom->parse($html);

    print "CourseName\tLink\n";

    # coursename && link
    print $dom->find('#mainTable > tr > td > a')->flatten->map(
        sub {
            if (index($_->attr('href'), 'javascript') < 0) {
                $_->text .
                "\t".
                $_->attr('href') .
                "\n";
            }
        }
    )->each;

    close ($info);
    warn "Done. $file closed\n";
}

main();
