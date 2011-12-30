package CSS::SCSS::Selector;
use Moose;
use namespace::autoclean;

has content => (
    is => 'rw',
    isa => 'Str',
);

sub as_string {
    my $self = shift;
    my $prefix = shift // '';
    
    # replace '&' with prefix, prepend $prefix otherwise
    my $content = $self->content;
    if ($content !~ s{[&]}{$prefix}xms) {
        $content = "$prefix $content" if $prefix;
    }
    return $content;
}

__PACKAGE__->meta->make_immutable;

1;
