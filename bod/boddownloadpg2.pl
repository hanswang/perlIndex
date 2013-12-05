#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

$| = 1;

sub main
{
    my $file = "<bod_pg_link.list";
    open my $info, $file or die "Can't open $file: $!";

    my $order = 1;
    while (my $line = <$info>)
    {
        my $newfile = sprintf '>pgstore/%03d.html', $order;

        print "Downloading .. ".$newfile."\n";

        my $data = get($line);

        open my $newinfo, $newfile or die "Can't open $newfile: $!";

        # debug output
        print $newinfo $data;

        close $newinfo;

        $order++;
    }

    close $info;
}

main();
