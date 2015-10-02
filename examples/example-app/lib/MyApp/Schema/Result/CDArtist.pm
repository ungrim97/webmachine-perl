package MyApp::Schema::Result::CDArtist;

use base 'DBIx::Class::Core';

__PACKAGE__->table('cd_artist');
__PACKAGE__->add_columns(
    artistid => {
        data_type      => 'integer',
        is_foreign_key => 1,
    },
    cdid => {
        data_type      => 'integer',
        is_foreign_key => 1,
    },
);

__PACKAGE__->belongs_to(artist => 'MyApp::Schema::Result::Artist', 'artistid');
__PACKAGE__->belongs_to(cd     => 'MyApp::Schema::Result::CD', 'cdid');

1;
