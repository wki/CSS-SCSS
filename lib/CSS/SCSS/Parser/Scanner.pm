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

# my @tokens;
# sub t {
#     # interpolation must get evaluated in STRING|IDENT
#     # IDEA:
#     #   - build a second grammar just being capable of 'expression'
#     #   - make 'expression' the start symbol
#     #   - scan STRING/IDENT content for #{ ... } things and evaluate expression
#     
#     push @tokens, [ @_ ];
#     # must return empty string, because we might be inside a replacement
#     return '';
# }

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
        # warn "before: text='$text', pos=${\pos $text}";
        
        while ((pos($text) // 0) < length $text) {
            # $text =~ m{\G \s* // .*? ^}xmsg and next;
            
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
        
        # warn "after: text='$text', pos=${\pos $text}";
        
        $self->pos( pos($text) // 0 );
        return $token;
    };
}

sub next_token {
    my $self = shift;
    
    return $self->tokenizer->();
}

# while (length($text)) {
#     no warnings;
#     $text =~ s{\G \s* // .*? ^}{}xms and next;
#     $text =~ s{\G \s* (/\* .*? \*/) \s*}{ t COMMENT => $1 }exms and next;
#     $text =~ s{\G \s* \@([a-z]+) \s*}{ t "AT_\U$1" }exms and next;
#     $text =~ s{\G \s* !important \s*}{ t 'IMPORTANT' }exms and next;
#     $text =~ s{\G \s* (\#[0-9a-fA-F]{3}(?:[0-9a-fA-F]{3})?) \s*}{ t HEXCOLOR => $1 }exms and next;
#     $text =~ s{\G \s* (['"]) ((?:[^\\\1] | \\.)*?) \1 \s*}{ t STRING => $2 }exms and next;
#     $text =~ s{\G \s* ([~|]?=) \s*}{ t ATTR_CMP => $1 }exms and next;
#     $text =~ s{\G \s+ }{ t 'SPACE' }exms and next;
#     $text =~ s{\G \s* (-?[_a-zA-Z][-_a-zA-Z0-9]*)}{t IDENT => $1}exms and next; ### INTERPOLATION
#     $text =~ s{\G \s* (\.\d+ | \d+ (?:\.\d*)?) \s* (%|em|ex|px|cm|mm|pt|pc|deg|rad|grad|ms|s|hz|khz)? \s*}{ t NUMBER => "$1$2" }exms and next;
#     
#     my $char = substr($text,0,1,'');
#     if (exists($symbol_for_char{$char})) {
#         t $symbol_for_char{$char} => $char;
#     } else {
#         t CHAR => $char;
#     }
# }

__PACKAGE__->meta->make_immutable;

1;
