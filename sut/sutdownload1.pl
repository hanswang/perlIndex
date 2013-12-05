#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

$| = 1;

sub main
{
    my $data = get("http://www.future.swinburne.edu.au/cwis/php_pages/webapps/marketing/coursesearch/inc/load/courseresultspage.php");

    print $data;
}

main();
