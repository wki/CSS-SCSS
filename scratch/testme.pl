#!/usr/bin/env perl
use strict;
use warnings;
use feature ':5.10';
use Data::Dumper;
use FindBin;
use lib "$FindBin::Bin/../lib";
use CSS::SCSS;

sub css;

my $scss = CSS::SCSS->new();
my $result = $scss->parse_string(css);

# $result is a scalar-ref of an array-ref
say Data::Dumper->Dump([$result], ['result']);
# say 'Markup is: ' . $scss->as_string;

say 'Done.';

exit;




sub css {
    return <<'CSS';
@charset "ebcdic";

// ignored comment -- not CSS compatible, however

@import blabla("asdf.css");

$color: #aabbcc;

* {
    color: $color;
}

div#main.class.selected[hello], div#nav.something:hover {
    $xxx: 12;
    font: 13px, 14px/26px;
    font: "Helvetica Regular";
    
    img { border: none !important; }
}

/* processed comment */

CSS
}
