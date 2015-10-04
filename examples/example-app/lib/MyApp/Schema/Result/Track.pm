package MyApp::Schema::Result::Track;

use base 'DBIx::Class::Core';

__PACKAGE__->table('track');
__PACKAGE__->add_columns(
    trackid => {
        data_type         => 'integer',
        is_auto_increment => 1,
    },
    name => {
        data_type => 'integer',
    },
    track_number => {
        data_type => 'integer',
    },
    cdid => {
        data_type      => 'integer',
        is_foreign_key => 1,
    }
);

__PACKAGE__->set_primary_key('trackid');

__PACKAGE__->has_many(track_artists => 'MyApp::Schema::Result::TrackArtist', 'trackid');
__PACKAGE__->many_to_many('artists', 'track_artists', 'artist');

__PACKAGE__->belongs_to(cd => 'MyApp::Schema::Result::CD', 'cdid');

sub editable_by {
    my ($self, $user) = @_;

    return $user->is_admin;
}

sub viewable_by {
    return 1;
}

1;
