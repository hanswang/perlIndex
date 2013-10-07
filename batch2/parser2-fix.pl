#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    print "Cricos Code\tPlan Code\tFaculty\tIndicative Fees\tMinimal Units\n";

    for my $i (1 .. 474) {
        my $file = sprintf '<store/%03d.html', $i;

        warn "processing file: $file ...\t";

        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);
        print $dom->find('div.degree-summary__codes ul.degree-summary__codes-column:first-of-type li.degree-summary__code:nth-of-type(2) span.degree-summary__code-text')->text;
        print "\t";

        print $dom->find('div.degree-summary__codes ul.degree-summary__codes-column:first-of-type li.degree-summary__code:first-of-type span.degree-summary__code-text')->text;
        print "\t";

        print $dom->at('div.intro span.first-owner')->text;
        print "\t";

        if ($dom->find('div.main div.body__inner dl:last-of-type dd')->size) {
            print $dom->find('div.main div.body__inner dl:last-of-type dd')->text;
        } else {
            print 'N/A';
        }
        print "\t";

        print trim($dom->find('div.main div.degree-summary li.degree-summary__requirements-units')->text);
        print "\n";

        close ($info);
        warn "Done. $file closed\n";
    }
}

main();
