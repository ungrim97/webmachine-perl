package MyApp::Schema::Result::CD;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('cd');
__PACKAGE__->add_columns(
    cdid => {
        data_type         => 'integer',
        is_auto_increment => 1,
    },
    name => {
        data_type => 'varchar',
    },
    release_date => {
        data_type => 'datetime',
    },
);

__PACKAGE__->has_many(tracks => 'MyApp::Schema::Result::Track', 'cdid');

__PACKAGE__->has_many(cd_artists => 'MyApp::Schema;:Result::CDArtist', 'cdid');
__PACKAGE__->many_to_many('artists', 'cd_artists', 'artist');


sub editable_by {
    my ($self, $user) = @_;

    return $user->is_admin;
}

sub viewable_by {
    return 1;
}

1;
