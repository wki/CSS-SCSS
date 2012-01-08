package CSS::SCSS::Value::Color::Hsl;
use Moose;
use namespace::autoclean;
extends 'CSS::SCSS::Value::Color';

sub as_string {
    my $self = shift;
    
    if (defined($self->a) && $self->a < 1) {
        my $a = sprintf('%0.2f', $self->a);
        $a =~ s{[.]? 0+ \z}{}xms;
        return sprintf('hsla(%d,%d,%d,%s)', $self->h, $self->s, $self->l, $a);
    } else {
        return sprintf('hsl(%d,%d,%d)', $self->h, $self->s, $self->l);
    }
}

### TODO: find a way to update r,g,b in case conversion is required

__PACKAGE__->meta->make_immutable;

1;
