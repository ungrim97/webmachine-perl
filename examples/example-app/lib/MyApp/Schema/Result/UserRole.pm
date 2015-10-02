package MyApp::Schema::Result::UserRole;

use base 'DBIx::Class::Core';

__PACKAGE__->table('user_role');
__PACKAGE__->add_columns(
    userid => {
        data_type => 'integer',
        is_foreign_key => 1,
    },
    roleid => {
        data_type       => 'integer',
        is_foreign_key  => 1,
    },
);

__PACKAGE__->belongs_to('role', 'MyApp::Schema::Result::Role', 'roleid');
__PACKAGE__->belongs_to('user', 'MyApp::Schema::Result::User', 'userid');

1;
