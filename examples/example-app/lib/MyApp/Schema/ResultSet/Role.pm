package MyApp::Schema::ResultSet::Role;

use base 'DBIx::Class::ResultSet';

sub does_admin {
    my ($self) = @_;

    return $self->single({name => 'admin'}) ? 1 : 0;
}

1;
