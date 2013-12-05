#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    my $file = sprintf "<dkCourseList";

    warn "processing file: $file ...\t";

    print "Coursename\tDegree\tLink\tCode\tCampus\n";
    local $/;
    open my $info, $file or die "Can't oepn data";
    my $html = <$info>;

    my $dom = Mojo::DOM->new;

    $dom->parse($html);

    print $dom->find('table:first-of-type tr')->flatten->map(
        sub{
            $_->at('a')->all_text."\t".
            "Bachelor\t".
            "http://www.deakin.edu.au/current-students/courses/". $_->at('a')->attr('href') ."\t".
            substr($_->at('td')->text, index($_->at('td')->text, '(')+1, 4) ."\t".
            trim($_->find('td:nth-of-type(2)')->all_text)."\n"
        }
    )->each;

    print $dom->find('table:nth-of-type(2) tr')->flatten->map(
        sub{
            $_->at('a')->all_text."\t".
            "Bachelor (Honours)\t".
            "http://www.deakin.edu.au/current-students/courses/". $_->at('a')->attr('href') ."\t".
            substr($_->at('td')->text, index($_->at('td')->text, '(')+1, 4) ."\t".
            trim($_->find('td:nth-of-type(2)')->all_text)."\n"
        }
    )->each;

    print $dom->find('table:nth-of-type(3) tr')->flatten->map(
        sub{
            $_->at('a')->all_text."\t".
            "Postgraduate\t".
            "http://www.deakin.edu.au/current-students/courses/". $_->at('a')->attr('href') ."\t".
            substr($_->at('td')->text, index($_->at('td')->text, '(')+1, 4) ."\t".
            trim($_->find('td:nth-of-type(2)')->all_text)."\n"
        }
    )->each;

    print $dom->find('table:nth-of-type(4) tr')->flatten->map(
        sub{
            $_->at('a')->all_text."\t".
            "Doctor\t".
            "http://www.deakin.edu.au/current-students/courses/". $_->at('a')->attr('href') ."\t".
            substr($_->at('td')->text, index($_->at('td')->text, '(')+1, 4) ."\t".
            trim($_->find('td:nth-of-type(2)')->all_text)."\n"
        }
    )->each;

    print $dom->find('table:nth-of-type(5) tr')->flatten->map(
        sub{
            $_->at('a')->all_text."\t".
            "Non-award\t".
            "http://www.deakin.edu.au/current-students/courses/". $_->at('a')->attr('href') ."\t".
            substr($_->at('td')->text, index($_->at('td')->text, '(')+1, 4) ."\t".
            trim($_->find('td:nth-of-type(2)')->all_text)."\n"
        }
    )->each;
    warn "Done with $file\n"; 

    close ($info);

}

main();
