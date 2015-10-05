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

has id => (is => 'ro', required => 1);
has artist => (
    is      => 'rw',
    lazy    => 1,
    builder => 1,
);

sub _build_artist {
    my ($self) = @_;

    return $self->schema->resultset('Artist')->find($self->id);
}

sub allowed_methods {return [qw/GET PUT POST DELETE OPTIONS HEAD/]}

sub path_part {return 'artists'};

sub to_json {
    my ($self) = @_;

    return JSON::encode_json({$self->artist->get_columns});
}

sub post_is_create { return 1 }

sub create_path_after_handler { return 1 }

sub create_path {
    my ($self) = @_;
    return '/'.$self->path_part.'/'.$self->id;
}

sub from_json {
    my ($self) = @_;

    # PUT needs to delete and create.
    if ($self->artist){
        $self->artist->delete;
    }

    my $artist = $self->schema->resultset('Artist')->new({
        %{ JSON::decode_json($self->request->content) },
        artistid => $self->id
    });

    $artist->insert;

    $self->artist($artist);

    return;
}

1;
