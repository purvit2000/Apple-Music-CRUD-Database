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