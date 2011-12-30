package CSS::SCSS::Parser;
use Moose;
# use MooseX::NonMoose;
use namespace::autoclean;
use feature ':5.10';

use CSS::SCSS::Comment;
use CSS::SCSS::Rule;
use CSS::SCSS::Block;

# every opened '{' opens a nesting level
# every nesting level might have a media-name and a selector prefix
# every nesting level has its own local variables but reads higher nexting level's variables
has nesting => (
    traits => ['Array'],
    is => 'rw',
    isa => 'ArrayRef[CSS::SCSS::Block]',
    default => sub { [ CSS::SCSS::Block->new() ] },
    handles => {
        open_block => 'push',
        close_block => 'pop',
    },
);

around open_block => sub {
    my ($orig, $self, $block) = @_;
    
    $self->block->add_block($block);
    $orig->($self, $block);
}

sub block {
    my $self = shift;
    
    return $self->nesting->[-1];
}

# add a rule to the latest open block
sub add_rule {
    my $self = shift;
    
    $self->block->add_rule(@_);
}

# add a rule to the latest open block
sub set_variable {
    my $self = shift;
    
    $self->block->set_variable(@_);
}

sub get_variable {
    my $self = shift;
    
    return $self->block->get_variable(@_);
}

__PACKAGE__->meta->make_immutable;

1;
