#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    print "commence\n";

    for my $i (1 .. 394) {
        my $file = sprintf '<sededStore/%03d.html', $i;

        warn "processing file: $file ...\t";

        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # commence
        my $commence = '';
        if ($dom->find('table.contentTable tr#Commences td:nth-of-type(2)')->size) {
            $commence = $dom->find('table.contentTable tr#Commences td:nth-of-type(2)')->all_text;
        }
        if (!(trim($commence) eq '')) {
            print $commence;
        } else {
            print "N/A";
        }
        print "\t";

        # name
        my $courseName = $dom->find('tr#Award td:nth-of-type(2)')->all_text;
        my $mText = '';
        my $f1text = '';
        my $f2text = '';
        if (index($courseName, ' of ') > 0) {
            $mText = substr($courseName, index($courseName, ' of ') + 4);
        } elsif (index($courseName, ' in ') > 0) {
            $mText = substr($courseName, index($courseName, ' in ') + 4);
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

        # major & study
        my $major = '';
        if ($dom->find('tr#program-content-seded')->size) {
            $major = $dom->find('tr#program-content-seded td:nth-of-type(2) a')->flatten->map(
                sub{
                    return $_->all_text . " / ";
                }
            )->each;
        }
        if (!(trim($major) eq '')) {
            print $major ."\t". $major ." / ". $mText;
        } else {
            print $mText ."\t". $mText;
        }
        print "\t";

        # assured
        my $assured = '';
        if ($dom->find('table#domTable')->size) {
            my $domRange = $dom->find('table#domTable tr')->size;
            for (my $i = 1; $i <= $domRange; $i++) {
                if ($dom->find('table#domTable tr:nth-of-type('.$i.') td:nth-of-type(1)')->all_text eq 'Entry Requirements') {
                    $assured = $dom->find('table#domTable tr:nth-of-type('.$i.') td:nth-of-type(2)')->all_text;
                    last;
                }
            }
        }

        # fee
        my $fee = '';
        # ielts
        my $ielts = '';
        # admission
        my $admission = '';
        if ($dom->find('table#interTable')->size) {
            my $range = $dom->find('table#interTable tr')->size;
            for (my $i = 1; $i <= $range; $i++) {
                if ($dom->find('table#interTable tr:nth-of-type('.$i.') td:nth-of-type(1)')->all_text eq 'Fee - Annual Fee 2014') {
                    $fee = $dom->find('table#interTable tr:nth-of-type('.$i.') td:nth-of-type(2)')->all_text;
                    next;
                }
                if ($dom->find('table#interTable tr:nth-of-type('.$i.') td:nth-of-type(1)')->all_text eq 'English Language Requirement') {
                    $ielts = $dom->find('table#interTable tr:nth-of-type('.$i.') td:nth-of-type(2)')->all_text;
                    next;
                }
                if ($dom->find('table#interTable tr:nth-of-type('.$i.') td:nth-of-type(1)')->all_text eq 'Extra Requirements - Int') {
                    $admission = $dom->find('table#interTable tr:nth-of-type('.$i.') td:nth-of-type(2)')->all_text;
                    next;
                }
            }
        } else {
            $admission = $assured;
        }

        if (!(trim($fee) eq '')) {
            print $fee;
        } else {
            print "N/A";
        }
        print "\t";

        if (!(trim($ielts) eq '')) {
            print $ielts;
        } else {
            print "N/A";
        }
        print "\t";

        if (!(trim($assured) eq '') && (index($courseName, 'Bachelor') >= 0)) {
            print $assured;
        } else {
            print "N/A";
        }
        print "\t";

        if (!(trim($admission) eq '')) {
            print $admission;
        } else {
            print "N/A";
        }

        close ($info);
        print "\n";
        warn "Done. $file closed\n";
    }
}

main();
