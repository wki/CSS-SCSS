package CSS::SCSS::Comment;
use Moose;
use namespace::autoclean;

has content => (
    is => 'rw',
    isa => 'Str',
);

sub as_string {
    my $self = shift;
    
    return "\n/* " . $self->content . " */\n";
}

__PACKAGE__->meta->make_immutable;

1;