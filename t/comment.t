use Test::More;
use Test::Exception;

use ok 'CSS::SCSS::Comment';

my $comment;


lives_ok { $comment = CSS::SCSS::Comment->new(content => 'foo') }
         'instantiation w/ list possible';

can_ok $comment, qw(content as_string);

like $comment->as_string, qr{\A \s* /\* \s* foo \s* \*/ \s* \z}xms,
     'foo-comment';


lives_ok { $comment = CSS::SCSS::Comment->new({content => 'bar'}) }
         'instantiation w/ hashref possible';
like $comment->as_string, qr{\A \s* /\* \s* bar \s* \*/ \s* \z}xms,
     'bar-comment';


done_testing;
