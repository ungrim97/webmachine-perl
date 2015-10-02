package MyApp::Schema::Result::Role;

use base 'DBIx::Class::Core';

__PACKAGE__->table('role');
__PACKAGE__->add_columns(
    roleid => {
        data_type           => 'integer',
        is_auto_increment   => 1,
    },
    name => {
        data_type => 'varchar',
        size      => 10,
    }
);

__PACKAGE__->has_many(role_users => 'MyApp::Schema::Result::UserRole', 'roleid');
__PACKAGE__->many_to_many('users', 'role_users', 'user');

sub editable_by {
    my ($self, $user) = @_;

    return $self->is_admin;
}

sub viewable_by {
    my ($self, $user) = @_;

    return $self->is_admin;
}

1;
