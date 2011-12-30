package CSS::SCSS::Block;
use Moose;
use MooseX::Types;
use CSS::SCSS::Selector;
use CSS::SCSS::Rule;
use namespace::autoclean;

# coercion issues a warning.
coerce 'CSS::SCSS::Selector'
    => from 'Str'
    => via { CSS::SCSS::Selector->new( content => $_ ) };

has parent => (
    is => 'rw', 
    isa => 'Maybe[CSS::SCSS::Block]',
);

has children => (
    traits => ['Array'],
    is => 'rw',
    isa => 'ArrayRef[CSS::SCSS::Block]',
    default => sub { [] },
    handles => {
        add_block => 'push',
    },
);

has selector => (
    is => 'rw',
    isa => 'Maybe[CSS::SCSS::Selector]',
);

has media => (
    is => 'rw',
    isa => 'Maybe[Str]',
);

has rules => (
    traits => ['Array'],
    is => 'rw',
    isa => 'ArrayRef[CSS::SCSS::Rule]',
    default => sub { [] },
    handles => {
        add_rule => 'push',
    },
);

has variable => (
    traits => ['Hash'],
    is => 'rw',
    isa => 'HashRef',
    default => sub { {} },
    handles => {
        get_variable => 'get',
        set_variable => 'set'
    },
);

around get_variable => sub {
    my ($orig, $self, $variable_name) = @_;
    
    return $orig->($self, $variable_name) 
        // ($self->parent 
                ? $self->parent->get_variable($variable_name)
                : undef);
};

sub as_string {
    my $self = shift;
    my $prefix = shift // '';
    
    # TODO: handle media
    return 
        join("\n",
             map { $_->as_string( $prefix . $self->selector ) } 
             @{$self->rules}
        );
}

__PACKAGE__->meta->make_immutable;

1;