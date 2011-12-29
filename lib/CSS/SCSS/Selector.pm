package CSS::SCSS::Selector;
use Moose;
use namespace::autoclean;

has content => (
    is => 'rw',
    isa => 'Str',
);

sub as_string {
    my $self = shift;
    my $prefix = shift;
    
    ### FIXME: how to handle '&' inside content???
    return join(' ', ($prefix // ()), $self->content);
}

__PACKAGE__->meta->make_immutable;

1;
