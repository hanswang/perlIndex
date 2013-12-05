#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

$| = 1;

sub main
{
    my $file = "<linkITfee.list";
    open my $info, $file or die "Can't open $file: $!";

    my $order = 1;
    while (my $line = <$info>)
    {
        my $newfile = sprintf '>storeItFee/%03d.html', $order;

        print "Downloading .. ".$newfile."\n";

        open my $newinfo, $newfile or die "Can't open $newfile: $!";

        my $ua = LWP::UserAgent->new();
        my $url = HTTP::Request->new(GET => $line);
        my $response = $ua->request($url);
        if ($response->is_success) {
            print $newinfo $response->as_string;
        } else {
            print $newinfo "Failed: ", $response->status_line, "\n";
        }

        close $newinfo;

        $order++;
    }

    close $info;
}

main();
