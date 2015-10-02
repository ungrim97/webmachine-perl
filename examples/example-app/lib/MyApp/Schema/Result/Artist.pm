package MyApp::Schema::Result::Artist;

use base 'DBIx::Class::Core';

__PACKAGE__->table('artist');
__PACKAGE__->add_column(
    artistid => {
        data_type           => 'integer',
        is_auto_increment   => 1,
    },
    name => {
        data_type => 'text',
    },
);

__PACKAGE__->has_many(artist_cds => 'MyApp::Schema::Result::CDArtists', 'artistid');
__PACKAGE__->many_to_many('cds', 'artist_cds', 'cd');

__PACKAGE__->has_many(artist_tracks => 'MyApp::Schema::Result::TrackArtist', 'artistid');
__PACKAGE__->many_to_many('tracks', 'artist_tracks', 'track');

sub editable_by {
    my ($self, $user) = @_;

    return $user->is_admin;
}

sub viewable_by {
    return 1;
}

1;
