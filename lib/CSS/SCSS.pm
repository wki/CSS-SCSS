package CSS::SCSS;
use Moose;
use namespace::autoclean;
use feature ':5.10';
# use Parse::RecDescent;

use CSS::SCSS::Comment;
use CSS::SCSS::Parser;

our $instance; # will get local()iced

# a parser instance
has parser => (
    is => 'ro',
    isa => 'Object',
    lazy => 1,
    default => \&_parser,
);

# full list of css rules and comment
has content => (
    traits => ['Array'],
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    handles => {
        add_content => 'push',
    },
);

sub as_string {
    my $self = shift;
    
    return join('', map { $_->as_string } @{$self->content});
}

sub _parser {
    my $parser = CSS::SCSS::Parser->new( CSS::SCSS::Parser::_grammar() )
        or die 'Bad grammar!';
    return $parser;
}

sub parse_string {
    my $self = shift;
    my $css  = shift;
    
    local $instance = $self;
    $self->parser->css($css);
}

# #######################################
# 
# sub process_charset {
#     my $charset = shift;
#     
#     say "*** charset: $charset";
#     '';
# }
# 
# sub process_import {
#     my ($import_file, $media) = @_;
# 
#     say "*** import: $import_file, media: @$media";
#     '';
# }
# 
# sub process_ruleset {
#     my ($selectors, $declarations) = @_;
# 
#     say "*** ruleset: @$selectors, declarations: @$declarations";
#     '';
# }
# 
# sub process_comment {
#     my ($comment) = @_;
# 
#     say "*** comment: $comment";
#     $instance->add_content( CSS::SCSS::Comment->new( { content => $comment } ) );
#     
#     '';
# }

# #######################################
# sub _grammar {
#     return <<'EOF';
# escape:
#     "\\" /[0-9a-fA-F]{1,6}/
# 
# hexcolor:
#     '#' /[0-9a-fA-F]{3}([0-9a-fA-F]{3})?/
# 
# string: # TODO: Unicode!!!
#     /([\"\'])([^\n\r\f\\\1]*|\\[nrtf]|escape)*\1/
# 
# ident: 
#     /-?[_A-Za-z\240-\377][-_A-Za-z0-9\240-\377]*/
# 
# ident_or_star:
#     ident | '*'
# 
# ident_or_string:
#     ident | string
# 
# function:
#     ident '(' expr ')'
# 
# ident_or_function:
#     ident | function
# 
# uri:
#     'url(' string ')'
#     {
#         $return = $item{string};
#     }
# 
# string_or_uri:
#     string | uri
# 
# hash:
#     '#' ident
# 
# class:
#     '.' ident
# 
# attrib_value:
#     /=|~=|\|=/ ident_or_string
# 
# attrib:
#     '[' ident attrib_value(?) ']'
# 
# pseudo:
#     ':' ident_or_function
# 
# hash_class_attrib_pseudo:
#     hash | class | attrib | pseudo
# 
# element_selector:
#     ident_or_star hash_class_attrib_pseudo(s?) # ?? # fake editor
#     { 
#         $return = [ $item{ident_or_star}, @{$item{hash_class_attrib_pseudo} || []} ];
#     }
# 
# simple_selector:
#     element_selector | hash_class_attrib_pseudo(s)
# 
# selector:
#     simple_selector(s /[+>]?/)
#     {
#         $return = $item{simple_selector};
#     }
# 
# pseudo_page:
#     ':' ident(s)
# 
# numeric:
#     /[-+]?(\d+([.]\d*)?|[.]\d+)/ /(em|ex|px|cm|mm|in|pt|pc|deg|rad|grad|ms|s|hz|khz|%)?/
# 
# term:
#     numeric | string | ident | uri | hexcolor | function
# 
# expr:
#     term term(s? /[\/,]/) # ?? # fake editor
# 
# declaration: 
#     ident ':' expr  /(!important)?/
#     {
#         $return = [ $item{ident}, $item{expr}, $item[-1] ];
#     }
# 
# comment:
#     /\/\* .*? \*\//xms
#     {
#         CSS::SCSS::process_comment($item[1]);
#     }
# 
# ruleset:
#     comment(?)
#     selector(s /,/)
#     '{' declaration(s? /;/) /;?/ '}' # ? # fake editor
#     { 
#         CSS::SCSS::process_ruleset($item{selector}, $item{declaration});
#     }
# 
# media:
#     comment(?)
#     '@media' ident(s /,/)
#     '{' ruleset(s) '}'
# 
# page:
#     comment(?)
#     '@page' pseudo_page(?)
#     '{'  declaration(s /;/) /;?/ '}'
# 
# css_content:
#     ruleset | media | page
# 
# css_import:
#     '@import' string_or_uri ident(s? /,/) ';' # ?? # fake editor
#     { CSS::SCSS::process_import(@item[2..3]) }
# 
# charset:
#     '@charset' string ';'
#     { CSS::SCSS::process_charset($item[2]) }
# 
# css:
#     charset(?) css_import(s?) css_content(s?) # ? # fake editor
# EOF
# }

__PACKAGE__->meta->make_immutable;

1;
