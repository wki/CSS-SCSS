package Value;
has value (is => 'rw');      # used as primary value, whatever the type may be
has extension (is => 'rw');  # used as helper value eg. transparency
sub as_string { $self->value }
sub apply(operator, operand) { ... }
sub multiple_of_base { 1 }
sub convert_to_class { die }      # universal conversion using common factor


package Number;

package Number::Percentage
sub multiple_of_base { 100 }
sub as_string { $self->value . '%' }
sub convert_to_class { ... }


package Unit;
sub multiple_of_base { die }   # base = class_value / multiple_of_base
has unit (is => 'ro');


package Unit::Absolute;
sub as_string { $self->value . $self->unit }
sub add { 
    (ref $self)->new(
        value => $self->value + $other->convert_to_class(ref $self),
        unit  => $self->unit,
    )
}

sub multiply {
    (ref $self)->new(
        value => $self->value * $other->convert_to_class('CSS::SCSS::Number')
        unit  => $self->unit
    )
}


package Unit::Absolute::Cm;
sub multiple_of_base { 10_000 }


package Unit::Absolute::Mm;
sub multiple_of_base { 1_000 }


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


