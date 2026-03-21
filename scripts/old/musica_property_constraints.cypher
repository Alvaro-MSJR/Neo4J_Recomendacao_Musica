//Key statement
CREATE CONSTRAINT `trackId_Song_key` IF NOT EXISTS
FOR (n: `Song`)
REQUIRE (n.`trackId`) IS NODE KEY;

//Load statement
UNWIND $nodeRecords AS nodeRecord
WITH *
WHERE NOT nodeRecord.`track_id` IN $idsToSkip AND NOT nodeRecord.`track_id` IS NULL
MERGE (n: `Song` { `trackId`: nodeRecord.`track_id` })
SET n.`trackName` = nodeRecord.`track_name`
SET n.`trackArtist` = nodeRecord.`track_artist`
SET n.`trackPopularity` = toInteger(trim(nodeRecord.`track_popularity`))
SET n.`trackAlbumId` = nodeRecord.`track_album_id`
SET n.`trackAlbumName` = nodeRecord.`track_album_name`
SET n.`trackAlbumReleaseDate` = datetime(nodeRecord.`track_album_release_date`)
SET n.`playlistName` = nodeRecord.`playlist_name`
SET n.`playlistId` = nodeRecord.`playlist_id`
SET n.`playlistGenre` = nodeRecord.`playlist_genre`
SET n.`playlistSubgenre` = nodeRecord.`playlist_subgenre`
SET n.`danceability` = toFloat(trim(nodeRecord.`danceability`))
SET n.`energy` = toFloat(trim(nodeRecord.`energy`))
SET n.`key` = toInteger(trim(nodeRecord.`key`))
SET n.`loudness` = toFloat(trim(nodeRecord.`loudness`))
SET n.`mode` = toLower(trim(nodeRecord.`mode`)) IN ['1','true','yes']
SET n.`speechiness` = toFloat(trim(nodeRecord.`speechiness`))
SET n.`acousticness` = nodeRecord.`acousticness`
SET n.`instrumentalness` = nodeRecord.`instrumentalness`
SET n.`liveness` = toFloat(trim(nodeRecord.`liveness`))
SET n.`valence` = toFloat(trim(nodeRecord.`valence`))
SET n.`tempo` = toFloat(trim(nodeRecord.`tempo`))
SET n.`durationMs` = toInteger(trim(nodeRecord.`duration_ms`));

