package MyApp::Resources::Artist;

use Moo;

use JSON ();
use Types::Standard qw/Int/;
use Web::Machine;

extends 'Web::Machine::Resource';

with 'MyApp::Roles::Auth';
with 'MyApp::Roles::Content';
with 'MyApp::Roles::Charset';
with 'MyApp::Roles::Exists';
with 'MyApp::Roles::ItemRoute';
with 'MyApp::Roles::Schema';

has artist_id => (is => 'ro', required => 1);
has artist => (
    is => 'lazy',
);

sub _build_artist {
    my ($self) = @_;

    return $self->schema->resultset('Artist')->find($self->artist_id);
}

sub allowed_methods {return [qw/GET PUT OPTIONS HEAD POST/]}

sub path_part {return 'artists'};

sub to_json {
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

1;
