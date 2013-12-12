#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    for my $i (1 .. 151) {
        my $file = sprintf '<store/%03d.html', $i;

        warn "processing file: $file ...\t";

        local $/;
        open my $finfo, $file or die "Can't oepn data";
        my $html = <$finfo>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # coursename
        my $coursename = $dom->find('#mainContentContainer h3')->all_text;
        $coursename =~ s/\n[\w| ]+//g;
        print $coursename . "\t";

        my $major = '';
        my $duration = '';
        my $faculty = '';
        my $cricos = '';
        my $campus = '';
        my $intake = '';

        my $atar = '';
        my $assured = '';
        my $admission = '';

        my $info = $dom->at('#program_info_container');
        if (not defined $info) {
            print "N/A\t";
            print "N/A\t";
            print "N/A\t";
            print "N/A\t";
            print "N/A\t";
            print "N/A\t";
            print "N/A\t";
            print "N/A\t";
            print "N/A";
            close ($finfo);
            print "\n";
            warn "Done. $file closed\n";
            next;
        }
        my $rowinfo = $info->content_xml;
        #print $rowinfo ."\n";

        if (index($rowinfo, 'QTAC') >= 0) {
            my $spoint = index(substr($rowinfo, index($rowinfo, 'QTAC')), '(') + 1 + index($rowinfo, 'QTAC');
            my $epoint = index(substr($rowinfo, $spoint), ')') + $spoint;
            $campus = substr($rowinfo, $spoint, $epoint - $spoint);
        }

        if (index($rowinfo, 'OP') >= 0) {
            my $spoint = index(substr($rowinfo, index($rowinfo, 'OP')), 'b>') + 2 + index($rowinfo, 'OP');
            my $epoint = index(substr($rowinfo, $spoint), '<b') + $spoint;
            $atar = substr($rowinfo, $spoint, $epoint - $spoint);
        }

        if (index($rowinfo, 'Duration') >= 0) {
            my $spoint = index(substr($rowinfo, index($rowinfo, 'Duration')), 'b>') + 2 + index($rowinfo, 'Duration');
            my $epoint = index(substr($rowinfo, $spoint), '<b') + $spoint;
            $duration = substr($rowinfo, $spoint, $epoint - $spoint);
        }

        if (index($rowinfo, 'Commence') >= 0) {
            my $spoint = index(substr($rowinfo, index($rowinfo, 'Commence')), 'b>') + 2 + index($rowinfo, 'Commence');
            my $epoint = index(substr($rowinfo, $spoint), '<b') + $spoint;
            $intake = substr($rowinfo, $spoint, $epoint - $spoint);
        }

        if (index($rowinfo, 'CRICOS') >= 0) {
            my $spoint = index(substr($rowinfo, index($rowinfo, 'CRICOS')), 'b>') + 3 + index($rowinfo, 'CRICOS');
            my $epoint = index(substr($rowinfo, $spoint), ' ') + $spoint;
            #print $spoint ."\n";
            #print $epoint ."\n";
            #print index($rowinfo, 'CRICOS') ."\n";
            $cricos = substr($rowinfo, $spoint, $epoint - $spoint);
            #print $cricos."\n";
        }

        if (index($rowinfo, 'rerequisite') >= 0) {
            my $spoint = index(substr($rowinfo, index($rowinfo, 'rerequisite')), 'b>') + 2 + index($rowinfo, 'rerequisite');
            my $epoint = index(substr($rowinfo, $spoint), '<b') + $spoint;
            $assured = substr($rowinfo, $spoint, $epoint - $spoint);
        }

        while(defined $info->next) {
            $info = $info->next;
            if ($info->type eq 'h5' and $info->all_text eq 'Majors') {
                $major .= $info->next->all_text;
                $info = $info->next;
            }
            if ($info->type eq 'h5' and $info->all_text eq 'Enquiries') {
                $faculty = $info->next->find('li:nth-of-type(2) a')->flatten->map( sub{$_->all_text} )->join(' / ');
                $info = $info->next;
            }
            if ($info->type eq 'h5' and index($info->all_text, 'dmission') >= 0) {
                $admission = $info->next->all_text;
                $info = $info->next;
            }
        }

        if (trim($major) eq '') {
            print 'N/A';
        } else {
            print $major;
        }
        print "\t";

        if (trim($duration) eq '') {
            print 'N/A';
        } else {
            print $duration;
        }
        print "\t";

        if (trim($faculty) eq '') {
            print 'N/A';
        } else {
            print $faculty;
        }
        print "\t";

        if (trim($cricos) eq '') {
            print 'N/A';
        } else {
            print $cricos;
        }
        print "\t";

        if (trim($campus) eq '') {
            print 'N/A';
        } else {
            print $campus;
        }
        print "\t";

        if (trim($intake) eq '') {
            print 'N/A';
        } else {
            print $intake;
        }
        print "\t";

        if (trim($atar) eq '') {
            print 'N/A';
        } else {
            print $atar;
        }
        print "\t";

        if (trim($assured) eq '') {
            print 'N/A';
        } else {
            print $assured;
        }
        print "\t";

        if (trim($admission) eq '') {
            print 'N/A';
        } else {
            print $admission;
        }

        close ($finfo);
        print "\n";
        warn "Done. $file closed\n";
    }
}

main();
