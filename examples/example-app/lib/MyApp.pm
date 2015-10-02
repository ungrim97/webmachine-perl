package MyApp;

use MyApp::Router;

use Moo;

sub as_app {
    my ($self) = @_;

    $self = ref $self ? $self : $self->new();

    my $router = MyApp::Router->build_routes_for_app('MyApp');

    return $router->to_app
}

1;
