package CSS::SCSS::Parser::Scanner;
use Moose;
use namespace::autoclean;

has source_text => (
    is => 'rw',
    isa => 'Str',
    trigger => \&_refresh_tokenizer,
);

has tokenizer => (
    is => 'rw',
    isa => 'CodeRef',
    lazy => 1,
    builder => '_build_tokenizer',
);

has pos => (
    is => 'rw',
    isa => 'Int',
);

# TODO: get line number and context from pos

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

sub _refresh_tokenizer {
    my $self = shift;
    
    $self->tokenizer($self->_build_tokenizer);
}

sub _build_tokenizer {
    my $self = shift;
    
    my $text = $self->source_text;
    
    return sub {
        no warnings;
        my $token = undef;
        
        while ((pos($text) // 0) < length $text) {
            next if $text =~ m{\G \s* // .*? ^}xmsgc;
            
            $text =~ m{\G \s* (/\* .*? \*/) \s*}xmsgc
                and do { $token = [ COMMENT => $1 ]; last };
            
            $text =~ m{\G \s* \@([a-z]+) \s*}xmsgc
                and do { $token = [ "AT_\U$1" ]; last };
            
            $text =~ m{\G \s* !important \s*}xmsgc
                and do { $token = [ 'IMPORTANT' ]; last };
            
            $text =~ m{\G \s* (\#[0-9a-fA-F]{3}(?:[0-9a-fA-F]{3})?) \s*}xmsgc
                and do { $token = [ HEXCOLOR => $1 ]; last };
            
            $text =~ m{\G \s* (['"]) ((?:[^\\\1] | \\.)*?) \1 \s*}xmsgc
                and do { $token = [ STRING => $2 ]; last };
            
            $text =~ m{\G \s* ([~|]?=) \s*}xmsgc
                and do { $token = [ ATTR_CMP => $1 ]; last };
            
            $text =~ m{\G \s+ }xmsgc
                and do { $token = [ 'SPACE' ]; last };
            
            $text =~ m{\G \s* (-?[_a-zA-Z][-_a-zA-Z0-9]*)}xmsgc ### INTERPOLATION
                and do { $token = [ IDENT => $1 ]; last };
            
            $text =~ m{\G \s* (\.\d+ | \d+ (?:\.\d*)?) \s* (%|em|ex|px|cm|mm|pt|pc|deg|rad|grad|ms|s|hz|khz)? \s*}xmsgc
                and do { $token = [ NUMBER => "$1$2" ]; last };
            
            my $pos = pos($text);
            my $char = substr($text,$pos,1);
            if (exists($symbol_for_char{$char})) {
                $token = [ $symbol_for_char{$char} => $char ];
            } else {
                $token = [ CHAR => $char ];
            }
            pos($text) = $pos+1;
            last;
        }
        
        $self->pos( pos($text) // 0 );
        return $token;
    };
}

sub next_token {
    my $self = shift;
    
    return $self->tokenizer->();
}

__PACKAGE__->meta->make_immutable;

1;
