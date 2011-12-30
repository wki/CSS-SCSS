package CSS::SCSS::Rule;
use Moose;
use MooseX::Types;
use CSS::SCSS::Selector;
use CSS::SCSS::Declaration;
use namespace::autoclean;

has selectors => (
    traits => ['Array'],
    is => 'rw',
    isa => 'ArrayRef[CSS::SCSS::Selector]',
    default => sub { [] },
    handles => {
        add_selector => 'push',
    },
);

has declarations => (
    traits => ['Array'],
    is => 'rw',
    isa => 'ArrayRef[CSS::SCSS::Declaration]',
    default => sub { [] },
    handles => {
        add_declaration => 'push',
    },
);

around add_selector => sub {
    my ($orig, $self, $selector) = @_;
    
    if (!ref $selector) {
        $selector = CSS::SCSS::Selector->new( { content => $selector } );
    }
    $orig->($self, $selector);
};

sub as_string {
    my $self = shift;
    my $prefix = shift;
    
    # how to handle empty selector array
    return join(',', map { $_->as_string($prefix) } @{$self->selectors})
           . '{' . join(';', map { $_->as_string($prefix) } @{$self->declarations}) . '}';
}

__PACKAGE__->meta->make_immutable;

1;
