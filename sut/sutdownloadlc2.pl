#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;

$| = 1;

sub main
{
    my $file = "<linkAggregator.list";
    open my $info, $file or die "Can't open $file: $!";

    my $order = 1;
    while (my $line = <$info>)
    {
        my $newfile = sprintf '>store/lc-%03d.html', $order;

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
