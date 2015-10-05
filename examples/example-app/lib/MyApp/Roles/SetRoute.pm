package MyApp::Roles::SetRoute;

use Moo::Role;

has router => (is => 'ro', required => 1);

sub add_route {
    my ($class, $router, $schema) = @_;

    my $resource_path = $class->path_part ||
        die "You must set the path_part for the resource";

    $router->add_route("/$resource_path" => (
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
