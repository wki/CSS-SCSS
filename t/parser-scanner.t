use strict;
use warnings;
use Test::More;
use Test::Exception;

use ok 'CSS::SCSS::Parser::Scanner';


# basic behavior
{
    my $scanner;
    lives_ok { $scanner = CSS::SCSS::Parser::Scanner->new() }
             'creating scanner lives 1';
    can_ok $scanner, qw(source_text tokenizer pos next_token);
    
    $scanner->source_text('/* bla */');
    is $scanner->source_text, '/* bla */', 'setting source text works';
    is ref $scanner->tokenizer, 'CODE', 'tokenizer is a coderef';
    ok !defined $scanner->pos, 'pos initially undefined';
    
    my $old_tokenizer = $scanner->tokenizer;
    
    $scanner->source_text('/* foo */');
    is $scanner->source_text, '/* foo */', 'changing source text works';
    ok $old_tokenizer ne $scanner->tokenizer, 'tokenizer freshly created';
}

# scanning tokens
{
    my $scanner;
    lives_ok { $scanner = CSS::SCSS::Parser::Scanner->new() }
             'creating scanner lives 2';
             
    # empty string
    $scanner->source_text('');
    ok !defined $scanner->next_token, 'empty: eof is undef';
    ok !defined $scanner->next_token, 'empty: eof reported repeatedly';
    ok !defined $scanner->next_token, 'empty: eof reported more than twice';
    
    # eof discovery
    $scanner->source_text(' /* baz */ ');
    is_deeply $scanner->next_token, 
              [ COMMENT => '/* baz */' ], 
              'comment recognized';
    ok !defined $scanner->next_token, 'simple: eof is undef';
    ok !defined $scanner->next_token, 'simple: eof reported repeatedly';
    ok !defined $scanner->next_token, 'simple: eof reported more than twice';
    
    # misc scenarios
    my @token_tests = (
        {
            name   => 'comment',
            source => " /* bar */\n// something\n  /*  baz  */",
            tokens => [ [COMMENT => '/* bar */'], [COMMENT => '/*  baz  */'] ],
        },
        {
            name   => 'AT-Name',
            source => ' @foo',
            tokens => [ ['AT_FOO'] ],
        },
        {
            name   => 'comment w/o space',
            source => ' !important',
            tokens => [ ['IMPORTANT'] ],
        },
        {
            name   => 'hex color',
            source => ' #456 #123acf',
            tokens => [ [HEXCOLOR => '#456'], [HEXCOLOR => '#123acf'] ],
        },
        {
            name   => 'double quoted string',
            source => ' "hello world"',
            tokens => [ [STRING => 'hello world'] ],
        },
        {
            name   => 'single quoted string',
            source => q{ 'hello world'},
            tokens => [ [STRING => 'hello world'] ],
        },
        {
            name   => 'attr compare oparator',
            source => ' = ~= |=',
            tokens => [ [ATTR_CMP => '='], [ATTR_CMP => '~='], [ATTR_CMP => '|='] ],
        },
        {
            name   => 'space',
            source => ' ',
            tokens => [ ['SPACE'] ],
        },
        {
            name   => 'simple indent',
            source => 'foo',
            tokens => [ [IDENT=> 'foo'] ],
        },
        {
            name   => 'dashed simple indent',
            source => '-foo',
            tokens => [ [IDENT=> '-foo'] ],
        },
        {
            name   => 'compound indent',
            source => 'foo-bar',
            tokens => [ [IDENT=> 'foo-bar'] ],
        },
        {
            name   => 'number',
            source => '42 41. 40.3 42px 13 %',
            tokens => [ [NUMBER => '42'], [NUMBER => '41.'], [NUMBER => '40.3'],
                        [NUMBER => '42px'], [NUMBER => '13%'] ],
        },
        {
            name   => 'single letter terminals',
            source => '{}()[];:,.#>*/+-$&',
            tokens => [ 
              ['OPEN_CURLY'   => '{'],  ['CLOSE_CURLY'  => '}'],
              ['OPEN_PAREN'   => '('],  ['CLOSE_PAREN'  => ')'],
              ['OPEN_BRACKET' => '['],  ['CLOSE_BRACKET'=> ']'],
              ['SEMICOLON'    => ';'],  ['COLON'        => ':'],
              ['COMMA'        => ','],  ['DOT'          => '.'],
              ['HASH'         => '#'],  ['GT'           => '>'],
              ['SPLASH'       => '*'],  ['SLASH'        => '/'],
              ['PLUS'         => '+'],  ['MINUS'        => '-'],
              ['DOLLAR'       => '$'],  ['AMPERSAND'    => '&'],
            ],
        },
        # {
        #     name   => 'comment w/o space',
        #     source => '/* bar */',
        #     tokens => [ [COMMENT => '/* bar */'] ],
        # },
    );
    
    foreach my $test_case (@token_tests) {
        $scanner->source_text($test_case->{source});
        my $i = 1;
        foreach my $token (@{$test_case->{tokens}}) {
            is_deeply $scanner->next_token, $token, "$test_case->{name}: token $i";
            $i++;
        }
        ok !defined $scanner->next_token, "$test_case->{name}: eof";
    }
}

done_testing;
