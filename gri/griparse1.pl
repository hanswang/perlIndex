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

    for my $i (1 .. 49) {
        my $file = sprintf '<indexList/%03d.html', $i;

        warn "processing file: $file ...\t";
        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

#        print "name\tlink\tcampus\tintake\tdegree\tmajor\n";

        $dom->find('#search-results article')->flatten->map(
            sub{
                my $name = $_->find('h3 a')->all_text;

                my $link = 'https://www148.griffith.edu.au' .$_->find('h3 a')->attr('href');

                my $campus = $_->find('li.coursecampus')->all_text;

                my $intake = $_->find('header ul:nth-of-type(1) li:nth-of-type(4)')->all_text;

                my $degree = $_->find('header ul:nth-of-type(1) li:nth-of-type(3)')->all_text;

                print $name.  "\t" .  $link.  "\t" .  $campus.  "\t" .  $intake.  "\t" .  $degree;

                print "\n";

            }
        )->each;

        close ($info);
        warn "Done. $file closed\n";
    }
}

main();
