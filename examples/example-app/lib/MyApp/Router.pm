package MyApp::Router;

use Moo;

use Module::Find qw/usesub/;
use Path::Router;
use Path::Tiny;
use Plack::App::Path::Router;
use Web::Machine;

sub build_routes_for_app {
    my ($self, $app) = @_;

    my $router = Path::Router->new();

    my @resources = usesub("${app}::Resources");
    for my $resource (@resources){
        $router = $resource->add_route($router);
    }

    return Plack::App::Path::Router->new(router => $router);
}

1;
