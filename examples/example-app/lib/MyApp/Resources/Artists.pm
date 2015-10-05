package MyApp::Resources::Artists;

use Moo;
use Web::Machine;

extends 'Web::Machine::Resource';

with 'MyApp::Roles::Auth';
with 'MyApp::Roles::SetRoute';
with 'MyApp::Roles::Schema';
with 'MyApp::Roles::Content';
with 'MyApp::Roles::Exists';
with 'MyApp::Roles::Charset';

has artists => (is => 'lazy');

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

sub from_json {
    my ($self) = @_;

    $self->schema->resultset('Artist')->update_or_create(JSON::decode_json($self->request->content));
}

1;
