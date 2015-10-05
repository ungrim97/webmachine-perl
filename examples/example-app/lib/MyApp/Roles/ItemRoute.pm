package MyApp::Roles::ItemRoute;

use Moo::Role;

use Types::Standard qw/Int/;
use Web::Machine;

has router => (is => 'ro');

sub add_route {
    my ($class, $router, $schema) = @_;

    my $resource_part = $class->path_part;
    $router->add_route("/$resource_part/:id" => (
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
                    id => $id,
                    schema    => $schema,
                    router    => $router,
                ],
            )->to_app;

            return $app->($request->env);
        }
    ));

    return $router;
}

1;
