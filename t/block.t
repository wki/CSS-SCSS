use strict;
use warnings;
use Test::More;
use Test::Exception;

use ok 'CSS::SCSS::Block';
use ok 'CSS::SCSS::Rule';
use ok 'CSS::SCSS::Selector';
use ok 'CSS::SCSS::Declaration';

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

# child management - linking
{
    my $parent;
    lives_ok { $parent = CSS::SCSS::Block->new() }
             'parent instantiation possible 1';

    my $child;
    lives_ok { $child = CSS::SCSS::Block->new() }
             'child instantiation possible 1';

    is scalar @{$parent->children}, 0, 'parent has no children so far';
    is scalar @{$child->children}, 0, 'child has no children';
    ok !defined $parent->parent, 'parent has no parent';
    ok !defined $child->parent, 'child has no parent';

    lives_ok { $parent->add_block($child) }
             'child can get added';

    is scalar @{$parent->children}, 1, 'parent has 1 child';
    is scalar @{$child->children}, 0, 'child has no children';
    ok !defined $parent->parent, 'parent still has no parent';
    is $child->parent, $parent, 'child has a parent';
}

# variable handling
{
    my $parent;
    lives_ok { $parent = CSS::SCSS::Block->new() }
             'parent instantiation possible 2';

    my $child;
    lives_ok { $child = CSS::SCSS::Block->new( parent => $parent ) }
             'child instantiation possible 2';

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

# rules
{
    my $block;
    lives_ok { $block = CSS::SCSS::Block->new() }
             'block instantiation possible';
    lives_ok {
        my $rule = CSS::SCSS::Rule->new();
        $rule->add_selector(
            CSS::SCSS::Selector->new( content => 'div' )
        );
        $rule->add_declaration(
            CSS::SCSS::Declaration->new( property => 'foo', value => 'bar' )
        );
        $block->add_rule($rule);
    } 'adding a rule lives';

    like $block->as_string,
         qr{\A \s* div \s* \{ \s* foo \s* : \s* bar \s* ; \s* \} \s* \z}xms,
         'block content with 1 rule looks good';

    $block->selector( CSS::SCSS::Selector->new( content => 'ul.xxx' ) );
    like $block->as_string,
         qr{\A \s* ul\.xxx \s+ div \s* \{ \s* foo \s* : \s* bar \s* ; \s* \} \s* \z}xms,
         'block content with 1 rule and a selector looks good';

    like $block->as_string('html'),
         qr{\A \s* html \s+ ul\.xxx \s+ div \s* \{ \s* foo \s* : \s* bar \s* ; \s* \} \s* \z}xms,
         'block content with 1 rule, prefix and a selector looks good';

    $block->selector(undef);

    lives_ok {
        my $rule = CSS::SCSS::Rule->new();
        $rule->add_selector(
            CSS::SCSS::Selector->new( content => 'span' )
        );
        $rule->add_declaration(
            CSS::SCSS::Declaration->new( property => 'bar', value => 'baz' )
        );
        $block->add_rule($rule);
    } 'adding another rule lives';

    like $block->as_string,
         qr{\A \s* div \s* \{ \s* foo \s* : \s* bar \s* ; \s* \}
               \s* span \s* \{ \s* bar \s* : \s* baz \s* ; \} \s* \z}xms,
         'block content with 2 rules looks good';
}

done_testing;
