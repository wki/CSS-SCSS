use strict;
use warnings;
use Test::More;
use Test::Exception;

use ok 'CSS::SCSS::Parser';


# basic behavior
{
    my $parser;
    lives_ok { $parser = CSS::SCSS::Parser->new() }
             'creating parser lives';
    can_ok $parser, qw(nesting parse block add_rule set_variable get_variable);
}

done_testing;
