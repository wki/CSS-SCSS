use strict;
use warnings;
use Test::More;
use Test::Exception;

use ok 'CSS::SCSS::Rule';
use ok 'CSS::SCSS::Selector';
use ok 'CSS::SCSS::Declaration';

# basic behavior
{
    my $rule;
    lives_ok { $rule = CSS::SCSS::Rule->new() }
             'instantiation possible 1';

    can_ok $rule,
           qw(selectors add_selector
              declarations add_declaration
              as_string);

    is_deeply $rule->selectors, [], 'selectors empty';
    is_deeply $rule->declarations, [], 'declarations empty';
}

# selector handling
{
    my $rule;
    lives_ok { $rule = CSS::SCSS::Rule->new() }
             'instantiation possible 2';
    is scalar @{$rule->selectors}, 0, 'no selectors in array';

    lives_ok { $rule->add_selector(CSS::SCSS::Selector->new(content => 'div')) } 
             'adding a selector lives';
    is scalar @{$rule->selectors}, 1, 'one selector in array';

    lives_ok { $rule->add_selector('span') } 
             'adding a string selector lives';
    is scalar @{$rule->selectors}, 2, 'two selectors in array';

    like $rule->as_string,
         qr{\A \s* div \s* , \s* span \s* \{ \s* \} \s* \z}xms,
         'joining selectors w/o prefix';

    like $rule->as_string ('ul'),
         qr{\A \s* ul \s+ div \s* , \s* ul \s+ span \s* \{ \s* \} \s* \z}xms,
         'joining selectors w/ prefix';
}

# selector + declaration handling
{
    my $rule;
    lives_ok { $rule = CSS::SCSS::Rule->new() }
             'instantiation possible 3';
    is scalar @{$rule->declarations}, 0, 'no declarations in array';

    lives_ok { $rule->add_selector('div') }
             'adding selector-part lives';
    lives_ok {
                $rule->add_declaration(
                    CSS::SCSS::Declaration->new( property => 'foo', value => 'bar' )
                )
             }
             'adding declaration-part lives';
    is scalar @{$rule->declarations}, 1, 'one declaration in array';

    like $rule->as_string,
         qr{\A \s* div \s* \{ \s* foo \s* : \s* bar \s* ; \} \s* \z}xms,
         'selector with rule';

    lives_ok {
                $rule->add_declaration(
                    CSS::SCSS::Declaration->new( property => 'baz', value => '42' )
                )
             }
             'adding another declaration-part lives';
    is scalar @{$rule->declarations}, 2, 'two declarations in array';

    like $rule->as_string,
         qr{\A \s* div \s* \{ \s* foo \s* : \s* bar \s* ; \s* baz \s* : \s* 42 \s* ;\} \s* \z}xms,
         'selector with 2 rules';
}

done_testing;
