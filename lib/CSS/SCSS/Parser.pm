package CSS::SCSS::Parser;
use Moose;
# use MooseX::NonMoose;
use namespace::autoclean;
use feature ':5.10';

use Marpa::XS;

use CSS::SCSS::Parser::Action;
use CSS::SCSS::Parser::Grammar;
use CSS::SCSS::Parser::Scanner;

our $DEBUG = 1; # 0 = off, 1 = verbose, 2 = more verbose

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

__PACKAGE__->meta->make_immutable;

1;
