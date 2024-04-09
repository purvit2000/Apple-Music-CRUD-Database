CREATE DATABASE musicsystem;
USE musicsystem;
drop database musicsystem;

DROP TABLE IF EXISTS subscription;
CREATE TABLE subscription (
    SubscriptionID int AUTO_INCREMENT,
    SubscriptionType varchar(255) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (SubscriptionID)
);
SELECT * FROM Subscription;

DROP TABLE IF EXISTS artist;
CREATE TABLE artist (
    ArtistID int AUTO_INCREMENT,
    ArtistName varchar(255) NOT NULL,
    PRIMARY KEY (ArtistID)
);
SELECT * FROM artist;

DROP TABLE IF EXISTS genre;
CREATE TABLE genre (
    GenreID int AUTO_INCREMENT,
    GenreName varchar(255) NOT NULL,
    PRIMARY KEY (GenreID)
);
SELECT * FROM genre;

DROP TABLE IF EXISTS user;
CREATE TABLE user (
    UserID int AUTO_INCREMENT,
    Username varchar(255) NOT NULL,
    Email varchar(255) NOT NULL,
    Password varchar(255) NOT NULL,
    SubscriptionID int,
    Subscription_Duration varchar(255) not null,
    PRIMARY KEY (UserID),
    FOREIGN KEY (SubscriptionID) REFERENCES subscription(SubscriptionID)
);
SELECT * FROM user;

DROP TABLE IF EXISTS album;
CREATE TABLE album (
    AlbumID int AUTO_INCREMENT,
    AlbumTitle varchar(255) NOT NULL,
    ReleaseYear int, -- Assuming only the year is stored
    PRIMARY KEY (AlbumID)
);
SELECT * FROM album;

DROP TABLE IF EXISTS playlist;
CREATE TABLE playlist (
    PlaylistID int AUTO_INCREMENT,
    PlaylistTitle varchar(255) NOT NULL,
    UserID int,
    PRIMARY KEY (PlaylistID),
    FOREIGN KEY (UserID) REFERENCES user(UserID)
);
SELECT * FROM playlist;

DROP TABLE IF EXISTS songs;
CREATE TABLE songs (
    SongID int AUTO_INCREMENT,
    SongTitle varchar(255) NOT NULL,
    Duration VARCHAR(5), -- Assuming duration in seconds
    ReleaseYear int, -- Assuming only the year is stored
    PRIMARY KEY (SongID)
);
SELECT * FROM songs;

DROP TABLE IF EXISTS SongPlaylist;
CREATE TABLE SongPlaylist (
    SongID int NOT NULL,
    PlaylistID int NOT NULL,
    PRIMARY KEY (SongID, PlaylistID),
    FOREIGN KEY (SongID) REFERENCES songs(SongID),
    FOREIGN KEY (PlaylistID) REFERENCES playlist(PlaylistID)
);
SELECT * FROM SongPlaylist;

DROP TABLE IF EXISTS SongArtist;
CREATE TABLE SongArtist (
    SongID int NOT NULL,
    ArtistID int NOT NULL,
    PRIMARY KEY (SongID, ArtistID),
    FOREIGN KEY (SongID) REFERENCES songs(SongID),
    FOREIGN KEY (ArtistID) REFERENCES artist(ArtistID)
);
SELECT * FROM SongArtist;

DROP TABLE IF EXISTS AlbumGenre;
CREATE TABLE AlbumGenre (
    AlbumID int NOT NULL,
    GenreID int NOT NULL,
    PRIMARY KEY (AlbumID, GenreID),
    FOREIGN KEY (AlbumID) REFERENCES album(AlbumID),
    FOREIGN KEY (GenreID) REFERENCES genre(GenreID)
);
SELECT * FROM AlbumGenre;

DROP TABLE IF EXISTS SongGenre;
CREATE TABLE SongGenre (
    SongID int NOT NULL,
    GenreID int NOT NULL,
    PRIMARY KEY (SongID, GenreID),
    FOREIGN KEY (SongID) REFERENCES songs(SongID),
    FOREIGN KEY (GenreID) REFERENCES genre(GenreID)
);
SELECT * FROM SongGenre;

DROP TABLE IF EXISTS SongAlbum;
CREATE TABLE SongAlbum (
    SongID int NOT NULL,
    AlbumID int NOT NULL,
    PRIMARY KEY (SongID, AlbumID),
    FOREIGN KEY (SongID) REFERENCES songs(SongID),
    FOREIGN KEY (AlbumID) REFERENCES album(AlbumID)
);
SELECT * FROM SongAlbum;

DROP TABLE IF EXISTS ArtistAlbum;
CREATE TABLE ArtistAlbum (
    ArtistID int NOT NULL,
    AlbumID int NOT NULL,
    PRIMARY KEY (ArtistID, AlbumID),
    FOREIGN KEY (ArtistID) REFERENCES artist(ArtistID),
    FOREIGN KEY (AlbumID) REFERENCES album(AlbumID)
);
SELECT * FROM ArtistAlbum;

-- create index for user table
CREATE INDEX idx_username ON user(Username);
CREATE INDEX idx_email ON user(Email);
CREATE INDEX idx_subscription_id ON user(SubscriptionID);

-- create index for role table
CREATE INDEX idx_artistname ON artist(ArtistName);
ALTER TABLE artist DROP INDEX idx_artistname;
DROP INDEX idx_artistname ON artist;

-- create index for genre table 
CREATE INDEX idx_genre_name ON genre(GenreName);

-- create index for album table 
CREATE INDEX idx_album_title ON album(AlbumTitle);
CREATE INDEX idx_album_release_year ON album(ReleaseYear);

-- create index for songs table 
CREATE INDEX idx_song_title ON songs(SongTitle);
CREATE INDEX idx_duration ON songs(Duration);
CREATE INDEX idx_songs_release_year ON songs(ReleaseYear);

-- create index for playlist table 
CREATE INDEX idx_playlist_title ON playlist(PlaylistTitle);
CREATE INDEX idx_user_id ON playlist(UserID);

-- create index for subscription table 
CREATE INDEX idx_subscription_type ON subscription(SubscriptionType);

-- create index for SongArtist table
CREATE INDEX idx_songartist_songid ON SongArtist(SongID);
CREATE INDEX idx_songartist_artistid ON SongArtist(ArtistID);

-- create index for AlbumGenre table
CREATE INDEX idx_albumgenre_albumid ON AlbumGenre(AlbumID);
CREATE INDEX idx_albumgenre_genreid ON AlbumGenre(GenreID);

-- create index for SongGenre table
CREATE INDEX idx_songgenre_songid ON SongGenre(SongID);
CREATE INDEX idx_songgenre_genreid ON SongGenre(GenreID);

-- create index for SongAlbum table
CREATE INDEX idx_songalbum_songid ON SongAlbum(SongID);
CREATE INDEX idx_songalbum_albumid ON SongAlbum(AlbumID);

-- create index for ArtistAlbum table
CREATE INDEX idx_artistalbum_artistid ON ArtistAlbum(ArtistID);
CREATE INDEX idx_artistalbum_albumid ON ArtistAlbum(AlbumID);

------------------------------------------------------------
-- create view to all songs with artist names
CREATE VIEW ViewSongsWithArtists AS
SELECT 
    s.SongID, 
    s.SongTitle, 
    a.ArtistName 
FROM 
    songs s
JOIN 
    SongArtist sa ON s.SongID = sa.SongID
JOIN 
    artist a ON sa.ArtistID = a.ArtistID;
SELECT * FROM ViewSongsWithArtists; -- for extection to view 

-- create View of Albums with Their Genres
CREATE VIEW ViewAlbumsWithGenres AS
SELECT 
    al.AlbumID, 
    al.AlbumTitle, 
    g.GenreName 
FROM 
    album al
JOIN 
    AlbumGenre ag ON al.AlbumID = ag.AlbumID
JOIN 
    genre g ON ag.GenreID = g.GenreID;
SELECT * FROM ViewAlbumsWithGenres;

-- create View of User Subscriptions
CREATE VIEW ViewUserSubscriptions AS
SELECT 
    u.UserID, 
    u.Username, 
    u.Email, 
    s.SubscriptionType, 
    s.Price 
FROM 
    user u
JOIN 
    subscription s ON u.SubscriptionID = s.SubscriptionID;
SELECT * FROM ViewUserSubscriptions;

-- create View of Playlists with Song Count
CREATE VIEW ViewPlaylistSongCount AS
SELECT 
    p.PlaylistID, 
    p.PlaylistTitle, 
    COUNT(sp.SongID) AS NumberOfSongs 
FROM 
    playlist p
LEFT JOIN 
    SongPlaylist sp ON p.PlaylistID = sp.PlaylistID
GROUP BY 
    p.PlaylistID, 
    p.PlaylistTitle;
SELECT * FROM ViewPlaylistSongCount;

-------------------------------------------------------------------
-- create a temporary Table for Detailed Song Information
CREATE TEMPORARY TABLE TempSongDetails AS
SELECT 
    s.SongID,
    s.SongTitle,
    s.Duration,
    s.ReleaseYear,
    a.ArtistName,
    al.AlbumTitle,
    g.GenreName
FROM 
    songs s
JOIN 
    SongArtist sa ON s.SongID = sa.SongID
JOIN 
    artist a ON sa.ArtistID = a.ArtistID
JOIN 
    SongAlbum sal ON s.SongID = sal.SongID
JOIN 
    album al ON sal.AlbumID = al.AlbumID
JOIN 
    SongGenre sg ON s.SongID = sg.SongID
JOIN 
    genre g ON sg.GenreID = g.GenreID;

-- create a temporary Table for User Playlist Overview
CREATE TEMPORARY TABLE TempUserPlaylistOverview AS
SELECT 
    p.UserID,
    p.PlaylistID,
    p.PlaylistTitle,
    COUNT(sp.SongID) AS NumberOfSongs,
    SUM(TIME_TO_SEC(s.Duration)) AS TotalDurationSeconds -- Convert duration to seconds before summing
FROM 
    playlist p
JOIN 
    SongPlaylist sp ON p.PlaylistID = sp.PlaylistID
JOIN 
    songs s ON sp.SongID = s.SongID
GROUP BY 
    p.PlaylistID;


-- create a temporary Table for Subscription Analysis
CREATE TEMPORARY TABLE TempSubscriptionAnalysis AS
SELECT 
    s.SubscriptionType,
    COUNT(u.UserID) AS NumberOfUsers,
    AVG(
        CASE 
            WHEN u.Subscription_Duration LIKE '%month' THEN CONVERT(SUBSTRING_INDEX(u.Subscription_Duration, ' ', 1), SIGNED)
        END
    ) AS AverageDurationMonths
FROM 
    subscription s
JOIN 
    user u ON s.SubscriptionID = u.SubscriptionID
GROUP BY 
    s.SubscriptionType;

-- can be manually drop or automatically dropped at end of database
DROP TEMPORARY TABLE IF EXISTS TempUserPlaylistOverview;

---------------------------------------------------------

-- Trigger to Log When a New Artist is Added
DELIMITER $$

CREATE TRIGGER AfterArtistInsert
AFTER INSERT ON artist
FOR EACH ROW
BEGIN
    INSERT INTO artist_log (ArtistID, ArtistName, LogDate) 
    VALUES (NEW.ArtistID, NEW.ArtistName, NOW());
END$$

DELIMITER ;

-- Trigger to Update User Subscription Duration
DELIMITER $$

CREATE TRIGGER AfterUserSubscriptionUpdate
AFTER UPDATE ON user
FOR EACH ROW
BEGIN
    IF OLD.SubscriptionID != NEW.SubscriptionID THEN
        INSERT INTO user_subscription_log (UserID, OldSubscriptionID, NewSubscriptionID, ChangeDate) 
        VALUES (NEW.UserID, OLD.SubscriptionID, NEW.SubscriptionID, NOW());
    END IF;
END$$

DELIMITER ;

-- Trigger for Deleting Songs from Playlists When a Song is Deleted
DELIMITER $$

CREATE TRIGGER BeforeSongDelete
BEFORE DELETE ON songs
FOR EACH ROW
BEGIN
    DELETE FROM SongPlaylist WHERE SongID = OLD.SongID;
END$$

DELIMITER ;
--------------------------------------------------------------------------

-- Adding a New Artist
DELIMITER $$
CREATE PROCEDURE AddNewArtist(IN artistName VARCHAR(255))
BEGIN
    INSERT INTO artist (ArtistName) VALUES (artistName);
END$$
DELIMITER ;

-- Adding a New Album for an Art
DELIMITER $$
CREATE PROCEDURE AddNewAlbum(IN albumTitle VARCHAR(255), IN releaseYear INT, IN artistID INT)
BEGIN
    INSERT INTO album (AlbumTitle, ReleaseYear) VALUES (albumTitle, releaseYear);
    SET @albumID = LAST_INSERT_ID();
    INSERT INTO ArtistAlbum (ArtistID, AlbumID) VALUES (artistID, @albumID);
END$$
DELIMITER ;

-- Adding a New Song to an Album
DELIMITER $$
CREATE PROCEDURE AddNewSong(IN songTitle VARCHAR(255), IN duration INT, IN releaseYear INT, IN albumID INT)
BEGIN
    INSERT INTO songs (SongTitle, Duration, ReleaseYear) VALUES (songTitle, duration, releaseYear);
    SET @songID = LAST_INSERT_ID();
    IF albumID IS NOT NULL THEN
        INSERT INTO SongAlbum (SongID, AlbumID) VALUES (@songID, albumID);
    END IF;
END$$
DELIMITER ;

-- Adding a Song to a Playlist
DELIMITER $$
CREATE PROCEDURE AddSongToPlaylist(IN playlistID INT, IN songID INT)
BEGIN
    INSERT INTO SongPlaylist (PlaylistID, SongID) VALUES (playlistID, songID);
END$$
DELIMITER ;

CALL AddNewArtist('New Artist'); -- use for exexution
------------------------------------------------------------------------------------------------

-- Function to get the name of an artist based on the artist ID
DELIMITER $$
CREATE FUNCTION GetArtistName(artistID INT) RETURNS VARCHAR(255)
READS SQL DATA
BEGIN
    DECLARE artist_name VARCHAR(255);
    SELECT ArtistName INTO artist_name FROM artist WHERE ArtistID = artistID;
    RETURN artist_name;
END$$
DELIMITER ;


-- Function to Get Artist Name by Song ID
DELIMITER $$

CREATE FUNCTION GetArtistNameBySongID(songID INT) RETURNS VARCHAR(255)
READS SQL DATA
BEGIN
    DECLARE artistName VARCHAR(255);
    SELECT a.ArtistName INTO artistName
    FROM artist a
    JOIN SongArtist sa ON a.ArtistID = sa.ArtistID
    WHERE sa.SongID = songID;
    RETURN artistName;
END;

DELIMITER ;

-- Function to Calculate the Total Duration of a Playlist
DELIMITER $$

CREATE FUNCTION GetPlaylistDuration(playlistID INT) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE totalDuration INT DEFAULT 0;
    SELECT SUM(TIME_TO_SEC(s.Duration)) INTO totalDuration
    FROM songs s
    JOIN SongPlaylist sp ON s.SongID = sp.SongID
    WHERE sp.PlaylistID = playlistID;
    RETURN totalDuration;
END$$

DELIMITER ;
DROP FUNCTION IF EXISTS GetPlaylistDuration;

