#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    my $file = 'programeIndex.xml';

    local $/;
    open my $info, $file or die "Can't oepn data";
    my $html = <$info>;

    my $dom = Mojo::DOM->new;
    $dom->parse($html);

    print "coursename\tlink\tcampus\topenInternational\tdegree\tduration\tcricos\tschool\n";

    print $dom->find('School')->map(
        sub{
            return $_->find('Program')->flatten->map(
                sub{
                    my $link = 'http://programfinder.federation.edu.au/ProgramFinder/displayProgram.jsp?ID=' . $_->attr('id');
                    return $link ."\n";
                }
            )->each
        }
    )->each;
    print "\n";

    close ($info);
}

main();
