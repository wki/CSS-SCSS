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

sub as_string {
    my $self = shift;
    my $prefix = shift;
    
    if (ref $self->value && $self->value->can('as_string')) {
        return $self->value->as_string($self->property);
    } else {
        return $self->property . ':' $self->value;
    }
}

__PACKAGE__->meta->make_immutable;

1;
