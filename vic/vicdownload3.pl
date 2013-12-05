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
    for my $i (1 .. 457) {
        my $file = sprintf '<store/%03d.html', $i;

        warn "processing file: $file ...\t";

        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # coursename
        my $coursename = $dom->find('div#main-content h1')->text;
        print $coursename;

        if ($dom->find('div#main-content .nav.nav-tabs')->size) {
            my $interLink = 'http://www.vu.edu.au' .$dom->find('div#main-content .nav.nav-tabs li:nth-of-type(2) a')->attr('href');
            my $newfile = sprintf '>store/%03d-it.html', $i;

            warn "Downloading internation version .. ".$newfile."\n";

            my $data = get($interLink);

            open my $newinfo, $newfile or die "Can't open $newfile: $!";

            # debug output
            print $newinfo $data;

            close $newinfo;

            print "\tinterversion";
        }

        close ($info);
        print "\n";
        warn "Done. $file closed\n";
    }
}

main();
