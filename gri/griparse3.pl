#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    print "name\tmajor\tstudy\n";

    for my $i (1 .. 486) {
        my $file = sprintf '<storeDmApply/%03d.html', $i;

        warn "processing file: $file ...\t";

        local $/;
        open my $info, $file or die "Can't oepn data";
        my $html = <$info>;

        my $dom = Mojo::DOM->new;

        $dom->parse($html);

        # name
        my $name = $dom->find('div#pageinfo h1')->all_text;
        print $name;
        print "\t";

        my $mText = '';
        my $f1text = '';
        my $f2text = '';
        if (index($name, ' of ') > 0) {
            $mText = substr($name, index($name, ' of ') + 4);
        } elsif (index($name, ' in ') > 0) {
            $mText = substr($name, index($name, ' in ') + 4);
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
        # n/a if exist with others, remove, if only exist, replace with mtext
        my $major = '';
        if ($dom->find('#courseSection ul.menu.nested.noaccordion.plus')->flatten->size > 0) {
            my $refmajor = $dom->find('#courseSection ul.menu.nested.noaccordion.plus')->flatten->map(
                sub{
                    if (index($_->parent->siblings('a')->all_text, 'Major') >= 0) {
                        return $_->find('li.openMajor > a')->flatten->map(
                            sub{$_->all_text}
                        )->each;
                    }
                }
            )->join(' / ')->trim;
            $major = $$refmajor;
            chomp($major);
        }
        if ($major eq ' /' || $major eq '/' || $major eq '/  /') {
            $major = '';
        }

        if ($major eq '') {
            print $mText . "\t" .$mText;
        } else {
            print $major . "\t" .$major . $mText;
        }

        close ($info);
        print "\n";
        warn "Done. $file closed\n";
    }
}

main();
