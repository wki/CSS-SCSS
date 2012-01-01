use strict;
use warnings;
use Test::More;
use Test::Exception;

use ok 'CSS::SCSS::Parser';
use ok 'CSS::SCSS::Parser::Action';
use ok 'CSS::SCSS::Parser::Grammar';

# basic behavior
{
    my $parser;
    lives_ok { $parser = CSS::SCSS::Parser->new() }
             'creating parser lives';
    can_ok $parser, qw(parse);
}

# parsing parts of CSS
{
    # get the original grammar for modification
    my %css_grammar = %{ CSS::SCSS::Parser::Grammar::css_grammar() };
    $css_grammar{inaccessible_ok} = 1; # avoid warnings during tests
    
    ### Selectors
    my $parser = CSS::SCSS::Parser->new( 
        { grammar => { %css_grammar, start => 'selectors' } }
    );
    
    my $result;
    lives_ok { $result = $parser->parse( 'div.foo , #nav span .bar' ) }
             'parsing selectors lives';
    is ref $$result, 'ARRAY', 'selectors is arrayref';
    is scalar @$$result, 2, '2 selectors in array';
    isa_ok ref $$result->[0], 'CSS::SCSS::Selector';
    isa_ok ref $$result->[1], 'CSS::SCSS::Selector';
    is $$result->[0]->content, 'div.foo', 'first selector is "div.foo"';
    is $$result->[1]->content, '#nav span .bar', 'first selector is "#nav span .bar"';
    
    ### Declaration
    undef $parser;
    $parser = CSS::SCSS::Parser->new( 
        { grammar => { %css_grammar, start => 'declaration' } }
    );
    
    undef $result;
    lives_ok { $result = $parser->parse( ' webkit-foo : 13 px ' ) }
             'parsing declaration 1 lives';
    isa_ok $$result, 'CSS::SCSS::Declaration';
    is $$result->property, 'webkit-foo', 'property is "webkit-foo"';
    is $$result->value, '13px', 'value is "13px"';
    ok !$$result->is_important, 'property is not important';

    undef $result;
    lives_ok { $result = $parser->parse( ' -foo-bar : 42% !important ' ) }
             'parsing declaration 2 lives';
    isa_ok $$result, 'CSS::SCSS::Declaration';
    is $$result->property, '-foo-bar', 'property is "-foo-bar"';
    is $$result->value, '42%', 'value is "42%"';
    ok $$result->is_important, 'property is important';
}

done_testing;
