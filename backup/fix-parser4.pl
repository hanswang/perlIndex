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
    print "Major Available\tStudy Area\tAcademic Admission Requirement\tAssured Knowledge\n";

    for my $i (1 .. 474) {
        my $file = sprintf '<store/%03d.html', $i;

        warn "processing file: $file ...\t";

        local $/;
        open my $info, $file or die "Can't oepn data";
        binmode $file, ':encoding(utf8)';
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # major
        my $final_major_text = '';
        if ($dom->find('div.main div.body__inner h2#specialisations')->size) {
            my @mp1 = $dom->find('div.main div.body__inner h2#specialisations')->next->find('div.body__inner__column li a')->text->each;
            for my $term1 (@mp1) {
                $final_major_text .= $term1."/ ";
            }
        } elsif ($dom->find('div.main div.body__inner h2#majors')->size) {
            my @mp2 = $dom->find('div.main div.body__inner h2#majors')->next->find('div.body__inner__column li a')->text->each;
            for my $term2 (@mp2) {
                my $mp2_count = () = $term2 =~ /\n/gi;
                warn "in majors list, here are $mp2_count \t";
                if ($mp2_count < 10) {
                    foreach my $mp2text (@mp2) {
                        $final_major_text .= $mp2text."/ ";
                    }
                }
            }
        }
        $final_major_text =~ s/\n/\/ /g;
        my $courseName = $dom->at('div.intro span.intro__degree-title__component')->text;
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
        if (!(trim($final_major_text) eq '')) {
            print $final_major_text."\t".$final_major_text.$mText;
        } else {
            print $mText."\t".$mText;
        }

        # study area
        print "\t";

        # assured knowledge
        my $assknow = '';
        if ($i < 71 && $dom->find('div.main div.body__inner h3#prerequisites')->size) {
            my $startR = $dom->find('div.main div.body__inner h3#prerequisites');
            while($startR->next->size && !($startR->next->attr('id') eq 'bonus-points') && !($startR->next->attr('id') eq 'indicative-fees') && !($startR->next->attr('id') eq 'program-requirements') && !($startR->next->attr('id') eq 'scholarships')) {
                $assknow .= $startR->next->all_text;
                $startR = $startR->next;
            }
        }
        if (!(trim($assknow) eq '')) {
            print $assknow;
        } else {
            print "N/A";
        }
        print "\t";

        # requirement
        my $reqText = '';
        if ($dom->find('div.main div.body__inner h2#admission-requirements')->size) {
            my $startR = $dom->find('div.main div.body__inner h2#admission-requirements');
            if ($i < 71) {
                while($startR->next->size && !($startR->next->attr('id') eq 'bonus-points') && !($startR->next->attr('id') eq 'indicative-fees') && !($startR->next->attr('id') eq 'program-requirements') && !($startR->next->attr('id') eq 'scholarships') && !($startR->next->attr('id') eq 'prerequisites')) {
                    $reqText .= $startR->next->all_text;
                    $startR = $startR->next;
                }
            } else {
                while($startR->next->size && !($startR->next->attr('id') eq 'bonus-points') && !($startR->next->attr('id') eq 'indicative-fees') && !($startR->next->attr('id') eq 'program-requirements') && !($startR->next->attr('id') eq 'scholarships')) {
                    $reqText .= $startR->next->all_text;
                    $startR = $startR->next;
                }
            }
        }
        if (!(trim($reqText) eq '')) {
            print $reqText;
        } else {
            print "N/A";
        }

        close ($info);
        print "\n";
        warn "Done. $file closed\n";
    }
}

main();
