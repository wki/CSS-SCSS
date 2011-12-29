package CSS::SCSS::Block;
use Moose;
use namespace::autoclean;

has parent => (
    is => 'rw', 
    isa => 'Object',
);

has selector => (
    is => 'rw',
    isa => 'Str',
    default => '',
);

has media => (
    is => 'rw',
    isa => 'Str',
    default => '',
);

has rules => (
    traits => ['Array'],
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    handles => {
        add_rule => 'push',
    },
);

has variable_value_for => (
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
    my $prefix = shift;
    
    # TODO: handle media
    return join("\n", map { $_->as_string( ($prefix // '') . $self->selector ) } @{$self->rules});
}

__PACKAGE__->meta->make_immutable;

1;