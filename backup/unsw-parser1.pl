#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    processFile('<store/postcOrg', '>postc.xls');
    processFile('<store/postrOrg', '>postr.xls');
    processFile('<store/underOrg', '>under.xls');
}

sub processFile
{
    local $/;

    my $file = $_[0];
    open my $info, $file or die "Can't oepn data";
    warn "processing file: $file ...\t";

    my $outName = $_[1];
    open my $out, $outName or die "can't write to file";

    my $html = <$info>;

    print $out "CourseName\tLink\tDegree\tFaculty\n";

    my $dom = Mojo::DOM->new;

    $dom->parse($html);

    if ($dom->find('table')->size) {
        for my $row ($dom->find('table.tabluatedInfo tr')) {
            my $course = $row->find('a')->text;
            print $out $course;
            print $out "\n";
            print $out "\n";

            my $href = $row->find('a')->attr('href');
            print $out $href;
            print $out "\n";
            print $out "\n";

            my $degree = $row->find('td:nth-of-type(2)')->text;
            print $out $degree;
            print $out "\n";
            print $out "\n";

            my $faculty = $row->find('td:nth-of-type(4)')->text;
            print $out $faculty;
        }
    }

    close ($out);
    close ($info);
    warn "Done. $file closed\n";
}

main();
