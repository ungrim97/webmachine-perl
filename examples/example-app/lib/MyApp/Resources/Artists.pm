package MyApp::Resources::Artists;

use Moo;
use Web::Machine;

extends 'Web::Machine::Resource';

has router => (is => 'ro');
has schema => (is => 'ro');

sub add_route {
    my ($class, $router, $schema) = @_;

    $router->add_route("/artists" => (
        defaults => {
            resource => $class,
        },
        target => sub {
            my ($request) = @_;

            my $app = Web::Machine->new(
                resource => $class,
                resource_args => [
                    router    => $router,
                    schema    => $schema,
                ],
            )->to_app;

            return $app->($request->env);
        }
    ));

    return $router;
}

1;
