use strict;
use warnings;
use Test::More;
use Test::Exception;

use ok 'CSS::SCSS::Value';
use ok 'CSS::SCSS::Value::Number';

# base class
{
    local $SIG{__WARN__} = sub {};

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
    
    undef $value;
    lives_ok { $value = CSS::SCSS::Value->new( { value => 13, unit => 'xx' } ) } 'new value with unit';
    is $value->as_string, '13xx', 'value with unit as_string is 13xx';
    is "$value", '13xx', 'value with unit stringified is 13xx';
}

# number
{
    # number w/o unit
    my $number;
    my $operand;
    lives_ok { $number = CSS::SCSS::Value::Number->new(32) } 'number from 32 works';
    is $number->unit, undef, 'number unit is undefined';
    is $number->value, 32, 'number value is 32';
    is $number->as_string, '32', 'number string is 32';
    is $number->convert_to_unit(), 32, 'number conversion to no-unit works';
    is $number->convert_to_unit('%'), 3200, 'number conversion to percent works';
    dies_ok { $number->convert_to_unit('px') } 'number conversion to px fails works';
    is "$number", '32', 'stringification gives 32';

    # number w/o unit + arithmetic
    $operand = CSS::SCSS::Value::Number->new(4);
    is $number->apply(add => $operand)->value, 36, 'add w/o unit works';
    is $number->apply(subtract => $operand)->value, 28, 'subtract w/o unit works';
    is $number->apply(multiply => $operand)->value, 128, 'multiply w/o unit works';
    is $number->apply(divide => $operand)->value, 8, 'divide w/o unit works';
    my $x = $number + $operand;
    isa_ok $x, 'CSS::SCSS::Value::Number';
    is $x->value, 36, 'add with operator works';
    $x = $number - $operand;
    is $x->value, 28, 'subtract with operator works';
    $x = $number * $operand;
    is $x->value, 128, 'multiply with operator works';
    $x = $number / $operand;
    is $x->value, 8, 'divide with operator works';

    # number w/ unit
    undef $number;
    lives_ok { $number = CSS::SCSS::Value::Number->new('14px') } 'number from 14px works';
    is $number->unit, 'px', 'number unit is px';
    is $number->value, 14, 'number value is 14';
    is $number->as_string, '14px', 'number string is 14px';
    is "$number", '14px', 'stringification gives 14px';

    dies_ok { $number->convert_to_unit('foo') } 'conversion px -> foo fails';
    ok $number->convert_to_unit('mm') > 4.9 && $number->convert_to_unit('mm') < 5,
       '14 px is approx 4.9mm';

    $operand = CSS::SCSS::Value::Number->new(4);
    dies_ok { $number->apply(add => $operand) } 'pt + 4 dies';
}


done_testing;
