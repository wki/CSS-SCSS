use strict;
use warnings;
use Test::More;
use Test::Exception;

use ok 'CSS::SCSS::Selector';

# no '&' in selector
{
    my $selector;
    lives_ok { $selector = CSS::SCSS::Selector->new(content => 'div.foo') }
             'instantiation possible';
    
    can_ok $selector, qw(content as_string);
    
    like $selector->as_string, qr{\A div \.foo \z}xms,
         'string value stringification w/o prefix';
    
    like $selector->as_string('bar'), qr{\A bar \s+ div \.foo \z}xms,
         'string value stringification w/ prefix';
}


# &' in selector
{
    my $selector;
    lives_ok { $selector = CSS::SCSS::Selector->new(content => '&:hover') }
             'instantiation with & possible';
    
    like $selector->as_string, qr{\A :hover \z}xms,
         'string value stringification & w/o prefix';
    
    like $selector->as_string('bar'), qr{\A bar:hover \z}xms,
         'string value stringification & w/ prefix';
}

done_testing;
