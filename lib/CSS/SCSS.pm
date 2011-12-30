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
    builder => '_build_parser',
);

# full list of css blocks, rules and comments
has content => (
    traits => ['Array'],
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    handles => {
        add_content => 'push',
    },
);

sub instance {
    return $instance;
}

sub as_string {
    my $self = shift;
    
    return join('', map { $_->as_string } @{$self->content});
}

sub _build_parser {
    return CSS::SCSS::Parser->new();
}

sub parse_string {
    my ($self, $css) = @_;
    
    local $instance = $self;
    $self->parser->parse($css);
}

__PACKAGE__->meta->make_immutable;

1;
