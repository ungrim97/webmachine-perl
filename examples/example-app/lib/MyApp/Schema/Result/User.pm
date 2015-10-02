package MyAPP::Schema::Result::User;

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('user');
__PACKAGE__->add_columns(
    userid => {
        data_type        => 'integer',
        is_auto_increment => 1,
    },
    name => {
        data_type   => 'varchar',
        size        => 100,
        is_nullable => 1
    },
    guid => {
        data_type   => 'varchar',
        size        => 20,
        is_nullable => 1,
    },
    username => {
        data_type => 'varchar',
    },
    password => {
        data_type   => 'varchar',
    },
);

__PACKAGE__->has_many(user_roles => 'MyApp::Schema::Result::UserRoles', 'userid');
__PACKAGE__->many_to_many(roles => 'user_roles', 'role');

sub can_edit {
    my ($self, $object) = @_;

    return $object->can('editable_by') && $object->editable_by($self);
}

sub can_view {
    my ($self, $object) = @_;

    return $object->can('viewable_by') && $object->viewable_by($self);
}

sub editable_by {
    my ($self, $editing_user) = @_;

    if ($editing_user->is_admin ||
        $editing_user->get_column('userid') eq $self->get_column('userid')
    ){
        return 1;
    }

    return 0;
}

sub viewable_by {
    my ($self, $viewing_user) = @_;

    if ($viewing_user->is_admin ||
        $viewing_user->get_column('userid') eq $self->get_column('userid')
    ){
        return 1;
    }

    return 0;
}

sub is_admin {
    my ($self) = @_;

    return $self->roles->does_admin ? 1 : 0
}

1;
