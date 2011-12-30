use strict;
use warnings;
use Test::More;
use Test::Exception;

use ok 'CSS::SCSS::Comment';

my $comment;


lives_ok { $comment = CSS::SCSS::Comment->new(content => 'foo') }
         'instantiation possible';

can_ok $comment, qw(content as_string);

like $comment->as_string, qr{\A \s* /\* \s* foo \s* \*/ \s* \z}xms,
     'stringification';


done_testing;
