#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Mojo::DOM;
use String::Util 'trim';

$| = 1;

sub main
{
    my $file = sprintf "<adld/indexList.list";

    warn "processing file: $file ...\t";

    local $/;
    open my $info, $file or die "Can't oepn data";
    my $html = <$info>;

    my $dom = Mojo::DOM->new;

    $dom->parse($html);

    #Couse name
    # link 
    print $dom->find('li > a')->map(sub{"http://www.adelaide.edu.au". $_->attr('href') ."\n"})->each;

    warn "Done with $file\n"; 

    close ($info);

}

main();
