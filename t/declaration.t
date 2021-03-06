use strict;
use warnings;
use Test::More;
use Test::Exception;

use ok 'CSS::SCSS::Declaration';

# string value
{
    my $declaration;
    lives_ok { $declaration = CSS::SCSS::Declaration->new(property => 'foo', value => 'bar') }
             'instantiation w/ string value possible';
    
    can_ok $declaration, qw(property value as_string);
    
    like $declaration->as_string, qr{\A \s* foo \s* : \s* bar \s* ; \s* \z}xms,
         'string value stringification';
    
    $declaration->is_important(1);
    like $declaration->as_string, qr{\A \s* foo \s* : \s* bar \s+ !important \s*; \s* \z}xms,
         'string value stringification w/ important';
}

# object value
{
    {
        package Xxx;
        use Moose;
        
        sub as_string {
            my $self = shift;
            my $prefix = shift;
            
            return "x $prefix y";
        }
    }
    
    my $declaration;
    my $o = Xxx->new();
    
    lives_ok { $declaration = CSS::SCSS::Declaration->new(property => 'bar', value => $o) }
             'instantiation w/ object value possible';
    
    like $declaration->as_string, qr{\A \s* x \s+ bar \s+ y \s* \z}xms,
         'object value stringification';
}

done_testing;
