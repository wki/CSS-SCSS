package CSS::SCSS::Parser::Action;
use Moose;
use namespace::autoclean;
use feature ':5.10';

our $DEBUG = 1;

sub css {
    return [ map { @{$_} } grep { defined } @_[1..$#_] ]
}

sub charset {
    # say Data::Dumper->Dump([ [@_] ],[ 'Charset' ]) if $DEBUG;
    return;
}

sub imports {
    say Data::Dumper->Dump([ [@_] ],[ 'Imports' ]) if $DEBUG;
    return;
}

sub function_call {
    # say Data::Dumper->Dump([ [@_] ],[ 'Function_Call' ]) if $DEBUG;
    return "$_[1]($_[3])";
}

sub css_content {
    return [ grep { defined } @_[1..$#_] ];
}

sub css_content_part {
    return $_[1];
}

sub ruleset {
    # say Data::Dumper->Dump([ [@_] ],[ 'Ruleset' ]) if $DEBUG;
    return { type => 'ruleset', selectors => $_[2], declations => $_[6] };
}

sub selectors {
    # say Data::Dumper->Dump([ [@_] ],[ 'Selectors' ]) if $DEBUG;
    return [ $_[1], @{$_[4] // []} ];
}

sub declaration {
    say Data::Dumper->Dump([ [@_] ],[ 'Declaration' ]) if $DEBUG;
    return { property => $_[2], value => $_[6], prio => $_[8] };
}

sub declarations {
    return [ $_[1], @{$_[4] // []} ];
}

sub important {
    # say Data::Dumper->Dump([ [@_] ],[ 'Prio' ]) if $DEBUG;
    return '!important';
}

sub variable_definition {
    say Data::Dumper->Dump([ [@_] ],[ 'Variable Definition' ]) if $DEBUG;
    return { type => 'variable_definition', variable => $_[3], value => $_[6] };
    return;
}

sub expression {
    # say Data::Dumper->Dump([ [@_] ],[ 'Expression' ]) if $DEBUG;
    return $_[1];
}

sub term {
    # say Data::Dumper->Dump([ [@_] ],[ 'Term' ]);
    return $_[1];
}

sub factor {
    # say Data::Dumper->Dump([ [@_] ],[ 'Factor' ]);
    return $_[1];
}

sub variable {
    say Data::Dumper->Dump([ [@_] ],[ 'Variable' ]);
    return 42; ### FIXME:
}

# default action simply concatenates strings
sub do_default {
    say Data::Dumper->Dump([ [@_] ],[ 'default action' ]); # if $DEBUG;
    return join('', grep { defined } @_[1..$#_])
}

__PACKAGE__->meta->make_immutable;

1;
