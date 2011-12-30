use strict;
use warnings;
use Test::More;
use Test::Exception;

use ok 'CSS::SCSS::Block';

# basic behavior
{
    my $block;
    lives_ok { $block = CSS::SCSS::Block->new() }
             'instantiation possible';
    
    can_ok $block,
           qw(parent children add_block
              selector media rules add_rule
              variable get_variable set_variable
              as_string);
    
    ok !defined $block->parent, 'parent undefined';
    is_deeply $block->children, [], 'children empty';
    ok !defined $block->media, 'media undefined';
    is_deeply $block->rules, [], 'rules empty';
    is_deeply $block->variable, {}, 'no variables';    
}

# variable handling
{
    my $parent;
    lives_ok { $parent = CSS::SCSS::Block->new() }
             'parent instantiation possible';
    
    my $child;
    lives_ok { $child = CSS::SCSS::Block->new( parent => $parent ) }
             'child instantiation possible';
    
    is $child->parent, $parent, 'child links to parent';
    
    # set a parent variable and check if we see it thru child
    lives_ok { $parent->set_variable(foo => 42) }
             'set parent variable lives';
    is_deeply $parent->variable, { foo => 42 }, 'parent variable in structure';
    is $parent->get_variable('foo'), 42, 'get parent variable';
    is $child->get_variable('foo'), 42, 'get parent variable thru child';
    
    # change the variable in child
    lives_ok { $child->set_variable(foo => 13) }
             'set parent variable lives';
    is_deeply $child->variable, { foo => 13 }, 'child variable in structure';
    is_deeply $parent->variable, { foo => 42 }, 'parent variable still in structure';
    is $parent->get_variable('foo'), 42, 'get parent variable';
    is $child->get_variable('foo'), 13, 'get child variable';
}

done_testing;
