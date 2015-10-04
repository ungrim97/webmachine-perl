package MyApp::Roles::Charset;

use Moo::Role;

sub default_charset { return 'UTF-8' }

sub charsets_provided { return ['UTF-8'] }

sub charsets_accepted { return ['UTF-8'] }

1;
