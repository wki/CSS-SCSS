package CSS::SCSS;
use Moose;
use namespace::autoclean;
use feature ':5.10';

use CSS::SCSS::Comment;
use CSS::SCSS::Rule;
use CSS::SCSS::Block;
use CSS::SCSS::Parser;

our $instance; # will get local()ised

has parser => (
    is => 'ro',
    isa => 'Object',
    lazy => 1,
    builder => '_build_parser',
);

has content => (
    is => 'rw',
    isa => 'CSS::SCSS::Block',
    default => sub { CSS::SCSS::Block->new() },
);

has nesting => (
    traits => ['Array'],
    is => 'rw',
    isa => 'ArrayRef[CSS::SCSS::Block]',
    builder => '_build_nesting',
    handles => {
        open_block => 'push',
        close_block => 'pop',
    },
);

sub _build_parser {
    return CSS::SCSS::Parser->new();
}

sub _build_nesting {
    my $self = shift;
    return [ $self->content ];
}

around open_block => sub {
    my ($orig, $self, $block) = @_;
    
    $block //= CSS::SCSS::Block->new();
    $orig->($self, $block);
    return $block;
};

sub instance {
    return $instance;
}

sub block {
    my $self = shift;

    return $self->nesting->[-1];
}

# add a rule to the latest open block
sub add_rule {
    my $self = shift;

    $self->block->add_rule(@_);
}

# add a rule to the latest open block
sub set_variable {
    my $self = shift;

    $self->block->set_variable(@_);
}

sub get_variable {
    my $self = shift;

    return $self->block->get_variable(@_);
}

sub as_string {
    my $self = shift;
    
    return join('', map { $_->as_string } @{$self->content});
}

sub parse_string {
    my ($self, $css) = @_;
    
    local $instance = $self;
    return $self->parser->parse($css);
}

__PACKAGE__->meta->make_immutable;

1;
