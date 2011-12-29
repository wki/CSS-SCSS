package CSS::SCSS::Parser::Action;
use strict;
use warnings;

sub css {
    return [ map { @{$_} } grep { defined } @_[1..$#_] ]
}

sub charset {
    # say Data::Dumper->Dump([ [@_] ],[ 'Charset' ]);
    return;
}

sub imports {
    # say Data::Dumper->Dump([ [@_] ],[ 'Imports' ]);
    return;
}

sub function_call {
    # say Data::Dumper->Dump([ [@_] ],[ 'Function_Call' ]);
    return "$_[1]($_[3])";
}

sub css_content {
    return [ grep { defined } @_[1..$#_] ];
}

sub css_content_part {
    return $_[1];
}

sub ruleset {
    # say Data::Dumper->Dump([ [@_] ],[ 'Ruleset' ]);
    return { type => 'ruleset', selectors => $_[2], declations => $_[6] };
}

sub selectors {
    # say Data::Dumper->Dump([ [@_] ],[ 'Selectors' ]);
    return [ $_[1], @{$_[4] // []} ];
}

sub declaration {
    say Data::Dumper->Dump([ [@_] ],[ 'Declaration' ]);
    return { property => $_[2], value => $_[6], prio => $_[8] };
}

sub declarations {
    return [ $_[1], @{$_[4] // []} ];
}

sub important {
    # say Data::Dumper->Dump([ [@_] ],[ 'Prio' ]);
    return '!important';
}

sub variable_definition {
    say Data::Dumper->Dump([ [@_] ],[ 'Variable Definition' ]);
    return { type => 'variable_definition', variable => $_[3], value => $_[6] };
    return;
}

sub expression {
    # say Data::Dumper->Dump([ [@_] ],[ 'Expression' ]);
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
    return join('', grep { defined } @_[1..$#_])
}

1;
