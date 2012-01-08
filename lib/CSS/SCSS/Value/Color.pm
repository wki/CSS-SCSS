package CSS::SCSS::Value::Color;
use Moose;
use Carp;
use namespace::autoclean;
extends 'CSS::SCSS::Value';

has [qw(r g b h s l)] => (
    is => 'rw',
    isa => 'Int',
);

has a => (
    is => 'rw',
    isa => 'Num',
);

has name => (
    is => 'rw',
    isa => 'Str',
);

# could be: name, #hexcolor, rgb, rgba // others? hsl, hsla
### FIXME: alternatively: use dereived classes
has format => (
    is => 'rw',
    isa => 'Str',
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
    
    croak 'Color base class cannot stringify';
}

sub do_add {
    my ($self, $operand) = @_;
    
    ...
}

sub do_subtract {
    my ($self, $operand) = @_;
    
    ...
}

sub do_multiply {
    my ($self, $operand) = @_;
    
    ...
}

sub do_divide {
    my ($self, $operand) = @_;
    
    ...
}


__PACKAGE__->meta->make_immutable;

1;
