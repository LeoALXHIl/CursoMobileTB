# TODO: Replace TMDB Movie Functionality with Spotify Tracks

## Step 1: Create SpotifyController (replace tmdb_controller.dart)
- Create lib/controllers/spotify_controller.dart with searchTracks method (adapt TMDB search to Spotify /v1/search?type=track).
- Include placeholder token 'undefined', comment on obtaining bearer token.

## Step 2: Create Track Model (replace movie.dart)
- Create lib/models/track.dart: id (String), name, artists (String), imagePath, rating.
- Include toMap() and fromMap() factory.

## Step 3: Update FirestoreController
- Rename methods: addFavoriteTrack, getFavoriteTracks, removeFavoriteTrack, updateTrackRating.
- Adapt image download to Spotify album images (smallest size).
- Update to use Track model.

## Step 4: Create SearchTrackView (rename/adapt search_movie_view.dart)
- Rename to lib/views/search_track_view.dart.
- Update texts to Portuguese for tracks/music.
- Change to call SpotifyController.searchTracks.
- Update ListView to display track name and artists.

## Step 5: Update FavoriteView
- Change to use Track model and getFavoriteTracks stream.
- Update UI texts, GridView to show track name, artists, local image.
- Fix delete icon visibility, update rating dialog.
- Change FAB to navigate to SearchTrackView.

## Step 6: Update Main.dart and Other Views (if needed)
- Check lib/main.dart, login_view.dart, registro_view.dart for navigation updates.

## Step 7: Delete Old Files
- Remove tmdb_controller.dart, movie.dart, search_movie_view.dart after migration.

## Step 8: Test and Followup
- Run flutter pub get, flutter run to test search, add, rate, delete tracks.
- Ensure Spotify token is replaced with valid one.
- Verify Firestore data structure changes.
