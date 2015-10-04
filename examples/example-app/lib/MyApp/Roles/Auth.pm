package MyApp::Roles::Auth;

use Moo::Role;

sub forbidden {
    return 0;
}

sub authorized {
    return 1;
}

1;
