package Value;
sub as_string {}
sub apply(operator, operand) { ... }
sub convert_to { die }      # universal conversion using common factor


package Number;
has value (is => 'rw');
sub common_factor { 1 }
sub as_string { $self->value }


package Number::Percentage
sub common_factor { 0.01 }
sub as_string { $self->value . '%' }
sub convert_to { ... }


package Unit;
sub common_factor { die }   # common_value = class_value * common_factor


package Unit::Absolute;
has value (is => 'rw');
has unit (is => 'ro');
sub as_string { $self->value . $self->unit }
sub add { 
    (ref $self)->new(
        value => $self->value + $other->convert_to(ref $self),
        unit  => $self->unit,
    )
}

sub multiply {
    (ref $self)->new(
        value => $self->value * $other->convert_to('CSS::SCSS::Number')
        unit  => $self->unit
    )
}


package Unit::Absolute::Cm;
sub common_factor { 10_000 }


package Unit::Absolute::Mm;
sub common_factor { 1_000 }


package Unit::Color;
has [qw(r g b h s l a)] => (is => 'rw');
# triggers auf r,g,b --> hsl errechnen
# triggers auf h,s,l --> rgb errechnen
sub add {
    (ref $self)->new(r, g, b, a, ...)
}


package Unit::Color::Hex;
sub as_string { sprintf '#%02xd%02xd%02xd', r, g, b }


package Unit::Color::Rgb;
sub as_string { sprintf 'rgb(%d,%d,%d)', r, g, b }


package Unit::Color::Rgba;
sub as_string { sprintf 'rgba(%d,%d,%d,%d)', r, g, b, a }


