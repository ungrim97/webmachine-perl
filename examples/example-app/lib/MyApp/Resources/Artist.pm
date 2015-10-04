package MyApp::Resources::Artist;

use Moo;

use JSON ();
use Types::Standard qw/Int/;
use Web::Machine;

extends 'Web::Machine::Resource';

with 'MyApp::Roles::ContentType';
with 'MyApp::Roles::Charset';
with 'MyApp::Roles::Exists';
with 'MyApp::Roles::Auth';

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

sub allowed_methods {return [qw/GET PUT OPTIONS HEAD POST/]}

sub as_json {
    my ($self) = @_;

    return JSON::encode_json({$self->artist->get_columns});
}

sub from_json {
    my ($self) = @_;

    if ($self->artist){
        $self->artist->update(JSON::decode_json($self->request->content));
    } else {
        $self->schema->resultset('Artist')->create(JSON::decode_json($self->request->content));
    }
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
