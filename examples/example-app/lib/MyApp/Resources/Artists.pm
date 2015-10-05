package MyApp::Resources::Artists;

use Moo;

use HTTP::Throwable;

extends 'Web::Machine::Resource';

with 'MyApp::Roles::Auth';
with 'MyApp::Roles::SetRoute';
with 'MyApp::Roles::Schema';
with 'MyApp::Roles::Content';
with 'MyApp::Roles::Exists';
with 'MyApp::Roles::Charset';

has artists => (
    is      => 'rw',
    lazy    => 1,
    builder => 1,
);

sub _build_artists {
    my ($self) = @_;

    [$self->schema->resultset('Artist')->all()];
}

sub path_part {return 'artists'}

sub allowed_methods {return [qw/GET PUT POST DELETE HEAD OPTIONS/]}

sub to_json {
    my ($self) = @_;

    return JSON::encode_json([map +{$_->get_columns}, @{$self->artists}]);
}

sub post_is_create { return 1 }

sub create_path_after_handler { return 1 }

sub create_path {
    my ($self) = @_;
    return '/'.$self->path_part;
}

sub from_json {
    my ($self) = @_;

    my $artists = JSON::decode_json($self->request->content);

    # To be idempotic we need to delete all data first
    # not just update it
    if ($self->artists){
        $self->artists->delete
    }

    for my $artist (@$artists){
        if ($self->request->method eq 'PUT' && ! $artist->{artistid}){
            http_throw(BadRequest => {
                message => 'Invalid Data: Must have a artistid primary key at:\n'.JSON::encode_json($artist),
            });
        }

        $self->schema->resultset('Artist')->create($artist);
    }

    $self->artists($self->_build_artists);

    return $self->to_json;
}

1;
