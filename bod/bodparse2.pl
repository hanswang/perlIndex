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
    for my $i (1 .. 129) {
        my $file = sprintf '<store/%03d.html', $i;

        warn "processing file: $file ...\t";
        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # coursename
        my $courseName = $dom->find('#two_col_left_holder h1')->all_text;
        $courseName =~ s/\n[\w| ]+//g;
        print $courseName ."\t";

        # college
        my $college = '';
        $college = $dom->find('#two_col_left_holder .contributor_content_div > table tr')->flatten->map(
            sub {
                if ( $_->find('td')->flatten->size ) {
                    if ( index($_->find('td:nth-of-type(1)')->all_text, 'Faculty') >= 0) {
                        return $_->find('td:nth-of-type(2)')->all_text;
                    }
                } else {
                    return '';
                }
            }
        )->join('');
        if (!(trim($college) eq '')) {
            print $college;
        } else {
            print "N/A";
        }
        print "\t";

        # cricos
        my $cricos = '';
        $cricos = $dom->find('#two_col_left_holder .contributor_content_div > table tr')->flatten->map(
            sub {
                if ( $_->find('td')->flatten->size ) {
                    if ( index($_->find('td:nth-of-type(1)')->all_text, 'CRICOS') >= 0) {
                        return $_->find('td:nth-of-type(2)')->all_text;
                    }
                } else {
                    return '';
                }
            }
        )->join('');
        if (!(trim($cricos) eq '')) {
            print $cricos;
        } else {
            print "N/A";
        }
        print "\t";

        # duration
        my $duration = '';
        $duration = $dom->find('#two_col_left_holder h1')->next->all_text;
        if (!(trim($duration) eq '')) {
            print $duration;
        } else {
            print "N/A";
        }
        print "\t";

        # intake
        my $intake = '';
        $intake = $dom->find('#two_col_left_holder .contributor_content_div > table tr')->flatten->map(
            sub {
                if ( $_->find('td')->flatten->size ) {
                    if ( index($_->find('td:nth-of-type(1)')->all_text, 'Starting') >= 0) {
                        return $_->find('td:nth-of-type(2)')->all_text;
                    }
                } else {
                    return '';
                }
            }
        )->join('');
        if (!(trim($intake) eq '')) {
            print $intake;
        } else {
            print "N/A";
        }

        close ($info);
        warn "Done. $file closed\n";
        print "\n";
    }
}

main();
