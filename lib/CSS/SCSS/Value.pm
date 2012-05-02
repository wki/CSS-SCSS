package CSS::SCSS::Value;
use Moose;
# use namespace::autoclean; # conflicts with overload
use overload
    '""' => \&as_string,
    '+'  => sub { $_[0]->apply(add => $_[1]) },
    '-'  => sub { $_[0]->apply(subtract => $_[1]) },
    '*'  => sub { $_[0]->apply(multiply => $_[1]) },
    '/'  => sub { $_[0]->apply(divide => $_[1]) },
    fallback => 1;


has value => (
    is => 'ro',
    isa => 'Any',
);

has extension => (
    is => 'ro',
    isa => 'Any',
);

has unit => (
    is      => 'ro',
    isa     => 'Str',
    default => ''
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

    return '' . $self->value . ($self->unit // '');
}

sub multiple_of_base { 1 }

sub convert_to_class {
    my ($self, $class) = @_;

    die 'convert_to_class() must be overloaded';
}

sub apply {
    my ($self, $operator, $operand) = @_;

    # my $other_value = $operand->convert_to_unit($self->unit);

    my $class = ref $self;
    my $method = "do_$operator";

    return $class->new(
        {
            value     => $self->$method($operand),
            extension => $self->extension
            unit      => $self->unit,
        }
    );
}

__PACKAGE__->meta->make_immutable;

1;
