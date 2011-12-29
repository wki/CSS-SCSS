#!/usr/bin/env perl
use strict;
use warnings;
use feature ':5.10';
use FindBin;
use lib "$FindBin::Bin/lib";
use CSS::SCSS;

my $scss = CSS::SCSS->new();

$scss->parse_string(<<'CSS');
@charset "utf-8";
@import url("some_file.css");

/* 
   a stupid comment
*/

a { color: red; }
div.item { padding: 0 }
* { font: helvetica }

CSS

say 'Markup is: ' . $scss->as_string;

say 'Done.';

exit;
