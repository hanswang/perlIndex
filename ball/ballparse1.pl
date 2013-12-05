#!/usr/bin/perl

use strict;
use warnings;

use XML::LibXML;

my $file = 'programeIndex.xml';

my $parser = XML::LibXML->new();
my $xmldoc = $parser->parse_file($file);

print Dumper $xmldoc;
