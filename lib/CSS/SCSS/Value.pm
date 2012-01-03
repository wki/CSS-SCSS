package CSS::SCSS::Value;
use Moose;
use namespace::autoclean;

has value => (
    is => 'ro',
    isa => 'Any',
);

has unit => (
    is => 'ro',
    isa => 'Str',
);

around BUILDARGS => sub {
    my $orig = shift;
    my $class = shift;
    
    my $args;
    
    if (scalar @_ == 1 && !ref $_[0]) {
        $args = $class->_build_args_from_value($_[0]);
    } elsif (ref $_[0] eq 'HASH') {
        $args = $_[0];
    } else {
        $args = { @_ };
    }
    
    return $class->$orig($args);
};

sub _build_args_from_value {
    my $class = shift;
    my $value = shift;
    
    return { value => $value };
}

sub as_string {
    my $self = shift;
    
    return '' . $self->value;
}

sub convert_to_unit {
    my ($self, $unit) = @_;
    
    die 'convert_to_unit() must be overloaded';
}

sub apply {
    my ($self, $operator, $operand) = @_;
    
    die 'apply() must be overloaded';
}

__PACKAGE__->meta->make_immutable;

1;
