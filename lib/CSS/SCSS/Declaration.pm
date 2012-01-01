package CSS::SCSS::Declaration;
use Moose;
use namespace::autoclean;

has property => (
    is => 'rw',
    isa => 'Str',
);

has value => (
    is => 'rw',
    isa => 'Any',
);

has is_important => (
    is => 'rw',
    isa => 'Bool',
    default => 0,
);

sub as_string {
    my $self = shift;
    my $prefix = shift;

    if (ref $self->value && $self->value->can('as_string')) {
        return $self->value->as_string($self->property);
    } else {
        return $self->property . ':'
             . $self->value
             . ($self->is_important ? ' !important' : '')
             . ';';
    }
}

__PACKAGE__->meta->make_immutable;

1;
