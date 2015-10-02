package MyApp::Resources::Artist;

use Moo;
use Types::Standard qw/Int/;
use Web::Machine;

extends 'Web::Machine::Resource';

sub add_route {
    my ($class, $router) = @_;

    $router->add_route("/artist/:id" => {
        validation => {
            id => Int,
        },
        defaults => {
            resource => $class,
        },
        target => sub {
            my ($request, $id) = @_;

            my $app = Web::Machine->new(
                resource => $class,
                resource_args => [
                    artist_id => $id,
                    router    => $router,
                ],
            )->to_app;

            return $app->($request->env);
        }
    });

    return $router;
}

1;
