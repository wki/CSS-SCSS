package CSS::SCSS::Value::Number;
use Moose;
use namespace::autoclean;
extends 'CSS::SCSS::Value';

# units in micro-meter
our %size = (
    mm =>  1_000,
    cm => 10_000,
    in => 25_400,
    pt => 25_400 / 72,
    pc => 25_400 /  6,
    px => 25_400 / 72, # original definition on a Mac
);


our %conversion_from_to = (
    '%' => { '' => 0.01 },
    ''  => { '%' => 100 },
    ( # dimension matrix mm .. px
        map {
            my $from = $_;
            $from => {
                map { $_ => 1 / $size{$_} * $size{$from} }
                keys %size
            }
        } keys %size
    ),
    # em <-> ex ???
);


sub _build_args_from_value {
    my $class = shift;
    my $value = shift // 0;
    
    my %args;
    
    if ($value =~ m{\A (.+?) (% | [a-zA-Z]+) \z }xms) {
        $args{value} = $1;
        $args{unit}  = lc $2;
    } else {
        $args{value} = $value;
    }
    
    return \%args;
}

sub convert_to_unit {
    my $self = shift;
    my $unit = shift // '';
    
    my $from = $self->unit // '';
    
    return $self->value if !$from && !$unit;
    
    die "Conversion from '$from' to '$unit' not possible"
        if !exists $conversion_from_to{$from} ||
           !exists $conversion_from_to{$from}->{$unit};
    
    return $self->value * $conversion_from_to{$from}->{$unit};
}

sub do_add {
    my ($self, $operand) = @_;
    
    my $other_value = $operand->convert_to_unit($self->unit);
    return $self->value + $other_value;
}

sub do_subtract {
    my ($self, $operand) = @_;
    
    my $other_value = $operand->convert_to_unit($self->unit);
    return $self->value - $other_value;
}

sub do_multiply {
    my ($self, $operand) = @_;
    
    my $other_value = $operand->convert_to_unit(undef);
    return $self->value * $other_value;
}

sub do_divide {
    my ($self, $operand) = @_;
    
    my $other_value = $operand->convert_to_unit(undef);
    return $self->value / $other_value;
}


__PACKAGE__->meta->make_immutable;

1;
