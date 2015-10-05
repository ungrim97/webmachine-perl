package MyApp::Roles::Exists;

use Moo::Role;

sub resource_exists {
    my ($self) = @_;

    my ($resource_key) = (ref $self) =~ /::([^:]+)$/;
    $resource_key = lc($resource_key);

    return unless $self->can($resource_key);

    return !! $self->$resource_key;
}

1;
