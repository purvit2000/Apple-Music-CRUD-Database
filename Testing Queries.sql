SELECT a.ArtistName, COUNT(sa.SongID) AS TotalSongs 
FROM artist a
JOIN SongArtist sa ON a.ArtistID = sa.ArtistID
GROUP BY a.ArtistName;

SELECT a.ArtistName, COUNT(sa.SongID) AS TotalSongs 
FROM artist a
JOIN SongArtist sa ON a.ArtistID = sa.ArtistID
GROUP BY a.ArtistName;

SELECT g.GenreName, COUNT(ag.AlbumID) AS AlbumCount
FROM genre g
LEFT JOIN AlbumGenre ag ON g.GenreID = ag.GenreID
GROUP BY g.GenreID;

SELECT DISTINCT a.ArtistName
FROM artist a
JOIN ArtistAlbum aa ON a.ArtistID = aa.ArtistID
JOIN album al ON aa.AlbumID = al.AlbumID
WHERE al.ReleaseYear >= YEAR(CURDATE()) - 5;

SELECT g.GenreName, AVG(TIME_TO_SEC(s.Duration)) AS AverageDurationSeconds
FROM genre g
JOIN SongGenre sg ON g.GenreID = sg.GenreID
JOIN songs s ON sg.SongID = s.SongID
GROUP BY g.GenreID;

SELECT u.Username, COUNT(p.PlaylistID) AS PlaylistCount
FROM user u
JOIN playlist p ON u.UserID = p.UserID
GROUP BY u.UserID
ORDER BY PlaylistCount DESC
LIMIT 1;

SELECT al.AlbumTitle, g.GenreName, al.ReleaseYear,
RANK() OVER(PARTITION BY g.GenreID ORDER BY al.ReleaseYear DESC) AS YearRank
FROM album al
JOIN AlbumGenre ag ON al.AlbumID = ag.AlbumID
JOIN genre g ON ag.GenreID = g.GenreID;

SELECT a.ArtistName, COUNT(DISTINCT sp.PlaylistID) AS PlaylistAppearances
FROM artist a
JOIN SongArtist sa ON a.ArtistID = sa.ArtistID
JOIN SongPlaylist sp ON sa.SongID = sp.SongID
GROUP BY a.ArtistID
ORDER BY PlaylistAppearances DESC;

SELECT a.ArtistName,
       MIN(al.ReleaseYear) AS FirstAlbumYear,
       MAX(al.ReleaseYear) AS LastAlbumYear,
       MAX(al.ReleaseYear) - MIN(al.ReleaseYear) AS CareerSpanYears
FROM artist a
JOIN ArtistAlbum aa ON a.ArtistID = aa.ArtistID
JOIN album al ON aa.AlbumID = al.AlbumID
GROUP BY a.ArtistName
HAVING CareerSpanYears > 0
ORDER BY CareerSpanYears DESC;

SELECT sg.GenreID, s.SongID, s.SongTitle,
       RANK() OVER(PARTITION BY sg.GenreID ORDER BY COUNT(sp.PlaylistID) DESC) AS PopularityRank
FROM SongGenre sg
JOIN songs s ON sg.SongID = s.SongID
LEFT JOIN SongPlaylist sp ON s.SongID = sp.SongID
GROUP BY sg.GenreID, s.SongID
ORDER BY sg.GenreID, PopularityRank;

SELECT a.ArtistID,
       a.ArtistName,
       COUNT(sp.PlaylistID) AS PlaylistAppearances,
       RANK() OVER (ORDER BY COUNT(sp.PlaylistID) DESC) AS PopularityRank
FROM artist a
JOIN SongArtist sa ON a.ArtistID = sa.ArtistID
JOIN SongPlaylist sp ON sa.SongID = sp.SongID
GROUP BY a.ArtistID
ORDER BY PlaylistAppearances DESC;

SELECT SongTitle,
       Duration,
       LEAD(Duration, 1) OVER (ORDER BY Duration) AS NextSongDuration,
       LAG(Duration, 1) OVER (ORDER BY Duration) AS PreviousSongDuration
FROM songs;

SELECT ReleaseYear,
       FIRST_VALUE(AlbumTitle) OVER (PARTITION BY ReleaseYear ORDER BY ReleaseYear ASC) AS FirstAlbum,
       LAST_VALUE(AlbumTitle) OVER (PARTITION BY ReleaseYear ORDER BY ReleaseYear ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastAlbum
FROM album
GROUP BY ReleaseYear, AlbumTitle;

SELECT ReleaseYear, GenreName, 
FIRST_VALUE(GenreName) OVER (PARTITION BY ReleaseYear ORDER BY GenreAppearance ASC) AS FirstGenreAppearance,
LAST_VALUE(GenreName) OVER (PARTITION BY ReleaseYear ORDER BY GenreAppearance DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS LastGenreAppearance
FROM (
    SELECT s.ReleaseYear, g.GenreName,
           ROW_NUMBER() OVER (PARTITION BY s.ReleaseYear, g.GenreName ORDER BY s.ReleaseYear) AS GenreAppearance
    FROM songs s
    JOIN SongGenre sg ON s.SongID = sg.SongID
    JOIN genre g ON sg.GenreID = g.GenreID
) AS GenreTrends
GROUP BY ReleaseYear, GenreName
ORDER BY ReleaseYear, GenreName;

SELECT a.ArtistName,
       g.GenreName,
       COUNT(*) AS SongsInGenre,
       COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY g.GenreName) AS PercentageOfGenre
FROM SongArtist sa
JOIN artist a ON sa.ArtistID = a.ArtistID
JOIN SongGenre sg ON sa.SongID = sg.SongID
JOIN genre g ON sg.GenreID = g.GenreID
GROUP BY a.ArtistName, g.GenreName
ORDER BY g.GenreName, PercentageOfGenre DESC;

SELECT al.AlbumTitle,
       AVG(CAST(s.Duration AS UNSIGNED)) AS AverageDuration
FROM album al
JOIN SongAlbum sa ON al.AlbumID = sa.AlbumID
JOIN songs s ON sa.SongID = s.SongID
GROUP BY al.AlbumTitle;

