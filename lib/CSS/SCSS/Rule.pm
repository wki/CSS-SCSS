package CSS::SCSS::Rule;
use Moose;
use namespace::autoclean;

has selectors => (
    traits => ['Array'],
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    handles => {
        add_selector => 'push',
    },
);

has declarations => (
    traits => ['Array'],
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    handles => {
        add_declaration => 'push',
    },
);

sub as_string {
    my $self = shift;
    my $prefix = shift;
    
    return join(',', map { $_->as_string($prefix) } @{$self->selectors})
           . '{' . join(';', map { $_->as_string($prefix) } @{$self->declarations}) . '}';
}

__PACKAGE__->meta->make_immutable;

1;
