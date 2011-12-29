package CSS::SCSS;
use Moose;
use namespace::autoclean;
use feature ':5.10';

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
    # my $parser = CSS::SCSS::Parser->new( CSS::SCSS::Parser::_grammar() )
    #     or die 'Bad grammar!';
    # return $parser;
}

sub parse_string {
    my $self = shift;
    my $css  = shift;
    
    # local $instance = $self;
    # $self->parser->css($css);
}

__PACKAGE__->meta->make_immutable;

1;
