package MyApp::Resources::Artist;

use Moo;
use Types::Standard qw/Int/;
use Web::Machine;

extends 'Web::Machine::Resource';

has router => (is => 'ro');
has artist_id => (is => 'ro', required => 1);
has artist => (
    is => 'lazy',
);
has schema => (is => 'ro');

sub _build_artist {
    my ($self) = @_;

    return $self->schema->resultset('Artist')->find($self->artist_id);
}

sub resource_exists {
    return !! shift->artist;
}

sub content_types_provided {
    my ($self) = @_;

    return [
        {'application/json' => 'as_json'}
    ];
}

sub as_json {

}


sub add_route {
    my ($class, $router, $schema) = @_;

    $router->add_route("/artists/:id" => (
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
