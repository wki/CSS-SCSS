package CSS::SCSS::Parser::Scanner;
use strict;
use warnings;

my %symbol_for_char = (
    '{' => 'OPEN_CURLY',    '}' => 'CLOSE_CURLY',
    '(' => 'OPEN_PAREN',    ')' => 'CLOSE_PAREN',
    '[' => 'OPEN_BRACKET',  ']' => 'CLOSE_BRACKET',
    ';' => 'SEMICOLON',     ':' => 'COLON',
    ',' => 'COMMA',         '.' => 'DOT',
    '#' => 'HASH',          '>' => 'GT',
    '*' => 'SPLASH',        '/' => 'SLASH',
    '+' => 'PLUS',          '-' => 'MINUS',
    '$' => 'DOLLAR',        '&' => 'AMPERSAND',
);

#
# Phase 1 -- sequentially scan terminals
#
my @tokens;
sub t {
    # interpolation must get evaluated in STRING|IDENT
    # IDEA:
    #   - build a second grammar just being capable of 'expression'
    #   - make 'expression' the start symbol
    #   - scan STRING/IDENT content for #{ ... } things and evaluate expression
    
    push @tokens, [ @_ ];
    # must return empty string, because we might be inside a replacement
    return '';
}

while (length($text)) {
    no warnings;
    $text =~ s{\A \s* // .*? ^}{}xms and next;
    $text =~ s{\A \s* (/\* .*? \*/) \s*}{ t COMMENT => $1 }exms and next;
    $text =~ s{\A \s* \@([a-z]+) \s*}{ t "AT_\U$1" }exms and next;
    $text =~ s{\A \s* !important \s*}{ t 'IMPORTANT' }exms and next;
    $text =~ s{\A \s* (\#[0-9a-fA-F]{3}(?:[0-9a-fA-F]{3})?) \s*}{ t HEXCOLOR => $1 }exms and next;
    $text =~ s{\A \s* (['"]) ((?:[^\\\1] | \\.)*?) \1 \s*}{ t STRING => $2 }exms and next;
    $text =~ s{\A \s* ([~|]?=) \s*}{ t ATTR_CMP => $1 }exms and next;
    $text =~ s{\A \s+ }{ t 'SPACE' }exms and next;
    $text =~ s{\A \s* (-?[_a-zA-Z][-_a-zA-Z0-9]*)}{t IDENT => $1}exms and next; ### INTERPOLATION
    $text =~ s{\A \s* (\.\d+ | \d+ (?:\.\d*)?) \s* (%|em|ex|px|cm|mm|pt|pc|deg|rad|grad|ms|s|hz|khz)? \s*}{ t NUMBER => "$1$2" }exms and next;
    
    my $char = substr($text,0,1,'');
    if (exists($symbol_for_char{$char})) {
        t $symbol_for_char{$char} => $char;
    } else {
        t CHAR => $char;
    }
}

1;
