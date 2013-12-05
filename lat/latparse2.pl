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
    my %clist = ();
    for my $f (1 .. 138) {
        my $file = sprintf '<store/%03d.html', $f;

        warn "processing file: $file ...\t";
        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        my $count = $dom->find('div#domestic .accordion .content > .course-container')->flatten->size;
        my $itcount = $dom->find('div#international .accordion .content > .course-container')->flatten->size;
        #print $count."\n";
        #print $itcount."\n";

        my $dm = $dom->find('div#domestic .accordion .content');
        my $it = $dom->find('div#international .accordion .content:last-of-type');
        for(my $i = 1; $i < $count + 1; $i++) {
            my $iti;
            if ($count == $itcount) {
                $iti = $i;
            } else {
                $iti = 1;
            }

            # coursename
            my $courseName = $dm->find('.course-container:nth-of-type('.$i.') .course-title a')->all_text;

            # duration
            my $duration = $dm->find('.course-container:nth-of-type('.$i.') > .course-summary dd:nth-of-type(1)')->all_text;

            # intake
            my $intake = $dm->find('.course-container:nth-of-type('.$i.') > dl.course-summary dd:nth-of-type(2)')->all_text;

            # atar & campus
            my @atar = ();
            my @campus = ();
            my $atarcount = $dm->find('.course-container:nth-of-type('.$i.') > dl.course-summary dd')->flatten->size;
            #print $atarcount ."\n";
            if ($atarcount > 2) {
                for (my $j = 3; $j < $atarcount + 1; $j++) {
                    if ($dm->find('.course-container:nth-of-type('.$i.') > dl.course-summary dd:nth-of-type('.$j.') span')->flatten->size) {
                        push(@atar, $dm->find('.course-container:nth-of-type('.$i.') > dl.course-summary dd:nth-of-type('.$j.') span')->all_text);
                    } else {
                        push(@atar, 'N/A');
                    }
                    push(@campus, $dm->find('.course-container:nth-of-type('.$i.') > dl.course-summary dd:nth-of-type('.$j.')')->text);
                }
            }

            # assured knowledge
            my $assured = $dm->find('.course-container:nth-of-type('.$i.') > .course-detail > dl.course-summary dd:nth-of-type(3)')->all_text;
            # admission
            my $admission = $dm->find('.course-container:nth-of-type('.$i.') > .course-detail > dl.course-summary dd:nth-of-type(4)')->all_text;

            #cricos & fee
            #ielts
            my $cricos = '';
            my $fee = '';
            my $ielts = '';
            if ($it->flatten->size) {
                my $itcricos = $it->find('.course-container:nth-of-type('.$iti.') .course-title a')->all_text;
                #print $iti . "hahahah\n";
                if(index($itcricos, $courseName) < 0) {
                    $iti = 1;
                    #print $itcount ."count\n";
                    while((index($itcricos, $courseName) < 0) && ($iti < $itcount)) {
                        $iti += 1;
                        $itcricos = $it->find('.course-container:nth-of-type('.$iti.') .course-title a')->all_text;
                        #print $courseName ." --- ".$itcricos ."hehehe".$iti."\n";
                    }
                    #print $iti . "hahahah\n";
                    if ($iti == $itcount + 1) {
                        $cricos = 'N/A';
                        $fee = 'N/A';
                        $ielts = 'N/A';
                    } else {
                        $cricos = substr $itcricos, length($courseName);
                        $fee = $it->find('.course-container:nth-of-type('.$iti.') > dl.course-summary dd:nth-of-type(3)')->all_text;
                        $ielts = $it->find('.course-container:nth-of-type('.$iti.') > .course-detail > dl.course-summary dd:nth-of-type(3)')->all_text;
                    }
                } else {
                    $cricos = substr $itcricos, length($courseName);
                    $fee = $it->find('.course-container:nth-of-type('.$iti.') > dl.course-summary dd:nth-of-type(3)')->all_text;
                    $ielts = $it->find('.course-container:nth-of-type('.$iti.') > .course-detail > dl.course-summary dd:nth-of-type(3)')->all_text;
                }
            } else {
                $cricos = 'N/A';
                $fee = 'N/A';
                $ielts = 'N/A';
            }

            my @courseItem = ();
            push(@courseItem, $courseName);
            if (!(trim($duration) eq '')) {
                push(@courseItem, $duration);
            } else {
                push(@courseItem, "N/A");
            }
            if (!(trim($intake) eq '')) {
                push(@courseItem, $intake);
            } else {
                push(@courseItem, "N/A");
            }
            push(@courseItem, [@atar]);
            push(@courseItem, [@campus]);
            if (!(trim($assured) eq '')) {
                push(@courseItem, $assured);
            } else {
                push(@courseItem, "N/A");
            }
            if (!(trim($admission) eq '')) {
                push(@courseItem, $admission);
            } else {
                push(@courseItem, "N/A");
            }
            push(@courseItem, $cricos);
            push(@courseItem, $fee);
            push(@courseItem, $ielts);
            push(@courseItem, $dom->find('div#content h1')->all_text);
            if( ! exists($clist{$courseName}) ) {
                @{$clist{$courseName}} = @courseItem;
            }

        }
        if ($count < $itcount) {
            $it = $dom->find('div#international .accordion .content:first-of-type');
            for(my $i = 1; $i < $itcount - $count + 1; $i++) {
                # coursename
                my $courseName = $it->find('.course-container:nth-of-type('.$i.') .course-title a')->all_text;
                #print $courseName."\n";

                # duration
                my $duration = '';
                $duration = $it->find('.course-container:nth-of-type('.$i.') > .course-summary dd:nth-of-type(1)')->all_text;

                # intake
                my $intake = '';
                $intake = $it->find('.course-container:nth-of-type('.$i.') > dl.course-summary dd:nth-of-type(2)')->all_text;

                my @atar = ();
                my @campus = ();
                push (@atar, 'N/A');
                push (@campus, $it->find('.course-container:nth-of-type('.$i.') > dl.course-summary dd:nth-of-type(4)')->all_text);

                my $assured = 'N/A';
                my $admission = $it->find('.course-container:nth-of-type('.$i.') > .course-detail > dl.course-summary dd:nth-of-type(4)')->all_text;

                my $cricos = substr $courseName, (index($courseName, '(')-1);

                my $fee = $it->find('.course-container:nth-of-type('.$i.') > dl.course-summary dd:nth-of-type(3)')->all_text;

                my $ielts = $it->find('.course-container:nth-of-type('.$i.') > .course-detail > dl.course-summary dd:nth-of-type(3)')->all_text;

                my @courseItem = ();
                push(@courseItem, $courseName);
                if (!(trim($duration) eq '')) {
                    push(@courseItem, $duration);
                } else {
                    push(@courseItem, "N/A");
                }
                if (!(trim($intake) eq '')) {
                    push(@courseItem, $intake);
                } else {
                    push(@courseItem, "N/A");
                }
                push(@courseItem, [@atar]);
                push(@courseItem, [@campus]);
                if (!(trim($assured) eq '')) {
                    push(@courseItem, $assured);
                } else {
                    push(@courseItem, "N/A");
                }
                if (!(trim($admission) eq '')) {
                    push(@courseItem, $admission);
                } else {
                    push(@courseItem, "N/A");
                }
                push(@courseItem, $cricos);
                push(@courseItem, $fee);
                push(@courseItem, $ielts);
                push(@courseItem, $dom->find('div#content h1')->all_text);
                if( ! exists($clist{$courseName}) ) {
                    @{$clist{$courseName}} = @courseItem;
                }
            }
        }

        close ($info);
        warn "Done. $file closed\n";
    }

    foreach my $key (keys %clist) {
        my $courseName = $key;
        my $duration = $clist{$key}[1];
        my $intake = $clist{$key}[2];
        my @atar = @{$clist{$key}[3]};
        my @campus = @{$clist{$key}[4]};
        my $assured = $clist{$key}[5];
        my $admission = $clist{$key}[6];
        my $cricos = $clist{$key}[7];
        my $fee = $clist{$key}[8];
        my $ielts = $clist{$key}[9];
        my $backupSchool = $clist{$key}[10];
        for (my $r = 0; $r < scalar @atar; $r ++ ) {
            print $courseName ."\t";

            if (!(trim($duration) eq '')) {
                print $duration;
            } else {
                print "N/A";
            }
            print "\t";

            if (!(trim($intake) eq '')) {
                print $intake;
            } else {
                print "N/A";
            }
            print "\t";

            print $atar[$r];

            print "\t";
            print $campus[$r];

            print "\t";
            print $cricos;

            print "\t";
            print $fee;

            print "\t";
            print $backupSchool;

            print "\t";
            print $assured;

            print "\t";
            print $admission;

            print "\t";
            print $ielts;

            print "\n";
        }
    }
}

main();
