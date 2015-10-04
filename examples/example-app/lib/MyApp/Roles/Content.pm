package MyApp::Roles::Content;

use Moo::Role;

sub content_types_provided {
    return [
        { 'application/json' => 'to_json' }
    ]
}

sub content_types_accepted {
    return [
        { 'application/json' => 'from_json' }
    ]
}

1;
