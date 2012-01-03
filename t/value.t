use strict;
use warnings;
use Test::More;
use Test::Exception;

use ok 'CSS::SCSS::Value';
use ok 'CSS::SCSS::Value::Number';

# base class
{
    my $value;
    lives_ok { $value = CSS::SCSS::Value->new( { value => 42 } ) } 'new value from hashref lives';
    
    can_ok $value, qw(value unit as_string convert_to_unit apply);
    is $value->unit, undef, 'value unit is undefined 1';
    is $value->value, 42, 'value is 42';
    is $value->as_string, '42', 'value as_string is 42';
    dies_ok { $value->apply() } 'apply not callable in base class';
    dies_ok { $value->convert_to_unit() } 'convert_to_unit not callable in base class';
    
    undef $value;
    lives_ok { $value = CSS::SCSS::Value->new( value => 24 ) } 'new value from list lives';
    is $value->unit, undef, 'value unit is undefined 2';
    is $value->value, 24, 'value is 24';
    
    undef $value;
    lives_ok { $value = CSS::SCSS::Value->new(13) } 'new value from scalar';
    is $value->unit, undef, 'value unit is undefined 3';
    is $value->value, 13, 'value is 13';
    
}

# number
{
    my $number;
    lives_ok { $number = CSS::SCSS::Value::Number->new(32) } 'number from 32 works';
    is $number->unit, undef, 'number unit is undefined';
    is $number->value, 32, 'number value is 32';
    
    undef $number;
    lives_ok { $number = CSS::SCSS::Value::Number->new('14px') } 'number from 14px works';
    is $number->unit, 'px', 'number unit is px';
    is $number->value, 14, 'number value is 14';
    
}
done_testing;
