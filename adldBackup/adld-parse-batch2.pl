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
    print "Coursename\tFaculty\tMajor\tAssured Knowledge\tAcademic Admission Requirement\n";

    for my $i (1 .. 484) {
        my $file = sprintf '<store/%03d.html', $i;

        warn "processing file: $file ...\t";

        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # coursename
        my $coursename = $dom->find('div.detail-glance h2')->all_text;
        # major
        my $major = '';
        if (($dom->find('div#page-content a#specialise')->size) && ($dom->find('div#page-content a#specialise')->siblings('.detail-data-content')->find('li')->flatten->size)) {
            print $dom->find('div#page-content a#specialise')->siblings('div.detail-data-content')->find('li')->flatten->map(sub{$_->all_text ." / "})->each;
        } else {
            my $mText = '';
            my $f1text = '';
            my $f2text = '';
            if (index($coursename, ' of ') > 0) {
                $mText = substr($coursename, index($coursename, ' of ') + 4);
            } else {
                $mText = 'Research';
            }
            if (index($mText, 'Bachelor of ') > 0) {
                $f1text = substr($mText, 0, index($mText, 'Bachelor of '));
                $f2text = substr($mText, index($mText, 'Bachelor of ') + 12);
                $mText = $f1text . $f2text;
            }
            if (index($mText, 'Master of ') > 0) {
                $f1text = substr($mText, 0, index($mText, 'Master of '));
                $f2text = substr($mText, index($mText, 'Master of ') + 10);
                $mText = $f1text . $f2text;
            }
            if (index($mText, ' (Honours)') > 0) {
                $f1text = substr($mText, 0, index($mText, ' (Honours)'));
                $f2text = substr($mText, index($mText, ' (Honours)') + 10);
                $mText = $f1text . $f2text;
            }
            if (index($mText, 'Honours ') > 0) {
                $f1text = substr($mText, 0, index($mText, 'Honours '));
                $f2text = substr($mText, index($mText, 'Honours ') + 8);
                $mText = $f1text . $f2text;
            }
            print $mText;
        }

        close ($info);
        print "\n";
        warn "Done. $file closed\n";
    }
}

main();
