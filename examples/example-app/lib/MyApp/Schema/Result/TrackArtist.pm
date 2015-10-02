package MyApp::Schema::Result::TrackArtist;

use base 'DBIx::Class::Core';

__PACKAGE__->table('track_artist');
__PACKAGE__->add_columns(
    artistid => {
        data_type      => 'integer',
        is_foreign_key => 1,
    },
    trackid => {
        data_type      => 'integer',
        is_foreign_key => 1,
    },
);

__PACKAGE__->belongs_to(track => 'MyApp::Schema::Result::Track', 'trackid');
__PACKAGE__->belongs_to(artist => 'MyApp::Schema::Result::Artist', 'artistid');

1;
