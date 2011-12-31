package CSS::SCSS::Parser;
use Moose;
# use MooseX::NonMoose;
use namespace::autoclean;
use feature ':5.10';

use Marpa::XS;

use CSS::SCSS::Parser::Action;
use CSS::SCSS::Parser::Grammar;
use CSS::SCSS::Parser::Scanner;

use CSS::SCSS::Comment;
use CSS::SCSS::Rule;
use CSS::SCSS::Block;

our $DEBUG = 1; # 0 = off, 1 = verbose, 2 = more verbose

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

sub do_default {
    warn "do_default (parser)";
}

sub parse {
    my ($self, $css) = @_;

    say 'Starting Parser...' if $DEBUG;

    my $scanner = CSS::SCSS::Parser::Scanner->new( { source_text => $css } );

    my $grammar = Marpa::XS::Grammar->new(css_grammar);
    $grammar->precompute;

    my $recognizer = Marpa::XS::Recognizer->new( { grammar => $grammar } );

    while (my $token = $scanner->next_token) {
        if ($token->[0] eq 'COMMENT') {
            # process comments in a different way
        } elsif (defined $recognizer->read( @$token )) {
            say "reading Token: @$token" if $DEBUG;
            say "expecting: " . join(', ', @{$recognizer->terminals_expected}) if $DEBUG > 1;
        } else {
            die "Error reading Token: @$token, " .
                'expecting: ' . join(', ', @{$recognizer->terminals_expected});
            ### TODO: find line, column and quote context
        };
    }
    
    return $recognizer->value();
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
