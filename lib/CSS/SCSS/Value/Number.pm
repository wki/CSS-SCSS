package CSS::SCSS::Value::Number;
use Moose;
use namespace::autoclean;
extends 'CSS::SCSS::Value';

# units in milli-meter
our %size = (
    mm =>  1_000,
    cm => 10_000,
    in => 25_400,
    pt => 25_400 / 72,
    pc => 25_400 /  6,
    px => 25_400 / 72,
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

sub as_string {
    my $self = shift;
    
    return '' . $self->value . ($self->unit // '');
}

sub convert_to_unit {
    my $self = shift;
    my $unit = shift // '';
    
    my $from = $self->unit // '';
    
    die "Conversion from '$from' to '$unit' not possible"
        if !exists $conversion_from_to{$from} ||
           !exists $conversion_form_to{$from}->{$unit};
    
    return $self->value * $conversion_form_to{$from}->{$unit};
}

sub apply {
    my ($self, $operator, $operand) = @_;
    
    my $other_value = $operand->convert_to_unit($self->unit);
    
    ### TODO: execute, create a new object, done.
}

__PACKAGE__->meta->make_immutable;

1;
