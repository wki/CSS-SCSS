use strict;
use warnings;
use Test::More;
use Test::Exception;

use ok 'CSS::SCSS::Rule';
use ok 'CSS::SCSS::Selector';

# basic behavior
{
    my $rule;
    lives_ok { $rule = CSS::SCSS::Rule->new() }
             'instantiation possible';

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
             'instantiation possible';

    lives_ok { $rule->add_selector(CSS::SCSS::Selector->new(content => 'div')) } 'adding a selector lives';
    lives_ok { $rule->add_selector('span') } 'adding a string selector lives';
    
    like $rule->as_string,
         qr{\A \s* div \s* , \s* span \s* \{ \s* \} \s* \z}xms,
         'joining selectors';
}

done_testing;
