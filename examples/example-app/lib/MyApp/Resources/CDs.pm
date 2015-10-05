package MyApp::Resources::CDs;

use Moo;

use HTTP::Throwable;

extends 'Web::Machine::Resource';

with 'MyApp::Roles::Auth';
with 'MyApp::Roles::SetRoute';
with 'MyApp::Roles::Schema';
with 'MyApp::Roles::Content';
with 'MyApp::Roles::Exists';
with 'MyApp::Roles::Charset';

has cds => (
    is      => 'rw',
    lazy    => 1,
    builder => 1,
);

sub _build_cds {
    my ($self) = @_;

    [$self->schema->resultset('CD')->all()];
}

sub path_part {return 'cds'}

sub allowed_methods {return [qw/GET PUT POST DELETE HEAD OPTIONS/]}

sub to_json {
    my ($self) = @_;

    return JSON::encode_json([map +{$_->get_columns}, @{$self->cds}]);
}

sub post_is_create { return 1 }

sub create_path_after_handler { return 1 }

sub create_path {
    my ($self) = @_;
    return '/'.$self->path_part;
}

sub from_json {
    my ($self) = @_;

    my $cds = JSON::decode_json($self->request->content);

    # To be idempotic we need to delete all data first
    # not just update it
    if ($self->cds){
        $self->cds->delete
    }

    for my $cd (@$cds){
        if ($self->request->method eq 'PUT' && ! $cd->{cdid}){
            http_throw(BadRequest => {
                message => 'Invalid Data: Must have a cdid primary key at:\n'.JSON::encode_json($cd),
            });
        }

        $self->schema->resultset('CD')->create($cd);
    }

    $self->cds($self->_build_cds);

    return $self->to_json;
}

1;
