package MyApp::Router;

use Moo;

use Module::Find qw/usesub/;
use MyApp::Schema;
use Path::Router;
use Path::Tiny;
use Plack::App::Path::Router;
use Web::Machine;

sub build_routes_for_app {
    my ($self, $app) = @_;

    my $router = Path::Router->new();

    my $schema = MyApp::Schema->connect('dbi:SQLite:dbname=testdb.sqlite');
    $schema->deploy;

    my @resources = usesub("${app}::Resources");
    for my $resource (@resources){
        $router = $resource->add_route($router, $schema);
    }

    return Plack::App::Path::Router->new(router => $router);
}

1;
