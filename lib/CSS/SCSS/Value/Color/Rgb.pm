package CSS::SCSS::Value::Color::Rgb;
use Moose;
use namespace::autoclean;
extends 'CSS::SCSS::Value::Color';

sub as_string {
    my $self = shift;
    
    if (defined($self->a) && $self->a < 1) {
        my $a = sprintf('%0.2f', $self->a);
        $a =~ s{[.]? 0+ \z}{}xms;
        return sprintf('rgba(%d,%d,%d,%s)', $self->r, $self->g, $self->b, $a);
    } else {
        return sprintf('rgb(%d,%d,%d)', $self->r, $self->g, $self->b);
    }
}

### TODO: find a way to update h,s,l in case conversion is required

__PACKAGE__->meta->make_immutable;

1;
