use strict;
use warnings;
use Test::More;
use Test::Exception;

use ok 'CSS::SCSS';


# basic behavior
{
    my $scss;
    lives_ok { $scss = CSS::SCSS->new() }
             'creating scss lives';
    can_ok $scss, qw(parser content instance
                     block open_block close_block
                     add_rule
                     set_variable get_variable
                     as_string
                     parse_string);

    ok !defined $scss->instance, 'instance() as object-method returns undef';
    ok !defined CSS::SCSS->instance, 'instance() as class-method returns undef';

    isa_ok $scss->parser, 'CSS::SCSS::Parser';
    isa_ok $scss->content, 'CSS::SCSS::Block';
    is ref $scss->nesting, 'ARRAY', 'nesting is an array-ref';
    is scalar @{$scss->nesting}, 1, 'nesting depth initially is 1';
    isa_ok $scss->block, 'CSS::SCSS::Block';
    is $scss->block, $scss->content, 'outermost nesting initially is current block';
    
    my $new_block;
    lives_ok { $new_block = $scss->open_block } 'creating an open block w/o args lives';
    isa_ok $new_block, 'CSS::SCSS::Block';
    is scalar @{$scss->nesting}, 2, 'nesting depth increases';
    is $scss->block, $new_block, 'new block returned by ->block()';
    
    lives_ok { $scss->close_block } 'closing a block lives';
    is scalar @{$scss->nesting}, 1, 'nesting depth decreases';
    is $scss->block, $scss->content, 'outermost block returned by ->block()';
}

done_testing;
