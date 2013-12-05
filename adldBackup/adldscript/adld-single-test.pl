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
    my $file = '<store/001.html';

    local $/;
    open my $info, $file or die "Can't oepn data";
    my $html = <$info>;

    my $dom = Mojo::DOM->new;

    $dom->parse($html);

    # coursename
    my $coursename = $dom->find('div.detail-glance h2')->text;
    print $coursename ."\t";

    # faculty
    my $faculty = $dom->find('div#page-content a#rules')->siblings('.detail-data-content')->find('a')->all_text;
    print $faculty ."\t";

    # cricos
    my $cricos = $dom->find('div#international_applicant table.ui-table:first-of-type tr:nth-of-type(5) td:nth-of-type(2)')->text;
    print $cricos ."\t";

    # intake
    my $intake = $dom->find('div#international_applicant table.ui-table:first-of-type tr:nth-of-type(4) td:nth-of-type(2)')->text;
    print $intake ."\t";

    # atar
    my $atar = $dom->find('div#domestic_applicant table.ui-table:first-of-type tr:nth-of-type(2) td:nth-of-type(2)')->text;
    print $atar ."\t";
    my $ib = $dom->find('div#domestic_applicant table.ui-table:first-of-type tr:nth-of-type(4) td:nth-of-type(2)')->text;
    print $ib ."\t";

    # tuition
    my $tuition = $dom->find('div#international_applicant table.ui-table:first-of-type tr:nth-of-type(3) td:nth-of-type(2)')->text;
    print $tuition ."\t";

    # ielts
    my $ielts = $dom->find('div#international_applicant table.ui-table:nth-of-type(2) tr:nth-of-type(2) td:nth-of-type(2)');
    my $o = $ielts->find('div:first-of-type')->text;
    my $r = $ielts->find('div:nth-of-type(2)')->text;
    my $l = $ielts->find('div:nth-of-type(3)')->text;
    my $s = $ielts->find('div:nth-of-type(4)')->text;
    my $w = $ielts->find('div:nth-of-type(5)')->text;
    print 'overall: '.$o.', r: '.$r.', l: '.$l.', s: '.$s.', w: '.$w."\t";

    # major
    my $major = '';
    if ($dom->find('div#page-content a#specialise')->size) {
        $major = $dom->find('div#page-content a#specialise')->siblings('div.detail-data-content')->map(sub{$_->find('a')->map(sub{$_->map(sub{$_->text.' / '})->each})->each})->each;
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
        $major = $mText;
    }
    print $major ."\t";

    # assured knowldge
    my $assurdknow = '';

    # admission
    my $admission = '';

    if (index($coursename, 'Bachelor') > 0) {
        my $start = $dom->at('div#domestic_applicant h5');
        $assurdknow = $dom->find()->text;
    } else {
        $assurdknow = $dom->find()->text;
    }

    print $assurdknow ."\t";
    print $admission ."\t";

    close ($info);
    print "\n";
    warn "Done. $file closed\n";
}

print "CourseName\tFaculty\tCricos\tinTake\tATAR\tIB\tTuition\tIELTS\tMajor\tAssured Knowledge\tAcademic Admission Requirement\n";

main();
