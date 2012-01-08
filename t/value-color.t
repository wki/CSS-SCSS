use strict;
use warnings;
use Test::More;
use Test::Exception;

use ok 'CSS::SCSS::Value::Color';
use ok 'CSS::SCSS::Value::Color::Rgb';

# color
{
    my $color;
    lives_ok { $color = CSS::SCSS::Value::Color->new( { r => 42, g => 42, b => 41 } ) }
             'color construction works';
    dies_ok { $color->as_string } 'color base class stringification dies';
}

# rgb color
{
    my $rgb;
    lives_ok { $rgb = CSS::SCSS::Value::Color::Rgb->new( { r => 42, g => 41, b => 40 } ) }
             'rgb construction works';
    is $rgb->as_string, 'rgb(42,41,40)', 'rgb stringification works';
    
    
    $rgb->a(0);
    is $rgb->as_string, 'rgba(42,41,40,0)', 'rgba stringification works 1';

    $rgb->a(0.42);
    is $rgb->as_string, 'rgba(42,41,40,0.42)', 'rgba stringification works 2';

    $rgb->a(0.5);
    is $rgb->as_string, 'rgba(42,41,40,0.5)', 'rgba stringification works 3';

    $rgb->a(1);
    is $rgb->as_string, 'rgb(42,41,40)', 'rgba stringification works 4';
}
done_testing;
