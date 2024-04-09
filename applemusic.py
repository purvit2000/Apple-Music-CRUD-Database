import mysql.connector
from mysql.connector import Error

# Database configuration
db_config = {
    "host": "localhost",
    "user": "root",
    "password": "123456",
    "database": "musicsystem",
}

# Create database connection
def create_connection():
    try:
        conn = mysql.connector.connect(**db_config)
        print("Connection successful")
        return conn
    except Error as e:
        print("Error while connecting to MySQL", e)
        return None

def execute_query(conn, query, params=None):
    cursor = conn.cursor()
    cursor.execute(query, params or ())
    return cursor.fetchall() if cursor.with_rows else conn.commit()

def print_colored(text, color_code):
    END = '\033[0m'  # Resets color
    print(f'\033[{color_code}m{text}{END}')
   
def colored_input(prompt, color_code):
    END = '\033[0m'  # Resets color
    return input(f'\033[{color_code}m{prompt}{END}')

def main_menu(conn):
    choice = display_main_menu()
   
    #crud_operations_menu
    choice = display_table_list()
    while True:
        if choice == "1":
            choice = handle_song_operation(conn)  
        elif choice == "2":
            choice = handle_playlist_operation(conn)
        elif choice == "3":
            choice = handle_song_playlist_operation(conn)
        elif choice == "4":
            choice = handle_artist_operation(conn)
        elif choice == "5":
            choice = handle_song_artist_operation(conn)
        elif choice == "6":
            choice = handle_album_operation(conn)
        elif choice == "7":
            choice = handle_song_album_operation(conn)
        elif choice == "8":
            choice = handle_genre_operation(conn)
        elif choice == "9":
            choice = handle_song_genre_operation(conn)
        elif choice == "10":
            choice = handle_album_genre_operation(conn)
        elif choice == "11":
            choice = handle_artist_album_operation(conn)
        elif choice == "12":
            choice = handle_subscription_operation(conn)
        elif choice == "13":
            choice = handle_user_operation(conn)
        elif choice == "14":
            choice = display_main_menu(conn)
            break
        else:
            #print("Invalid choice, please choose again.")
            choice = display_table_list()
            #break
            
def display_main_menu():
    print_colored("\n=== Content Management System ===", 35)
    print_colored("1. To Modify the Data", 33)
    print_colored("2. Exit", 33)
    return colored_input("Enter your choice (1-2): ", 36)
    
def display_table_list():
    print_colored("\n=== To Modify the Data by Table ===", 35)
    print("1. Songs Table")
    print("2. Playlist Table")
    print("3. Song Playlist Table")
    print("4. Artist Table")
    print("5. Song Artist Category")
    print("6. Album Tag")
    print("7. Song Album Table")
    print("8. Genre Table")
    print("9. Song Genre Blogs")
    print("10. Album Genre Content")
    print("11. Artist Album Roles")
    print("12. Subscription Table")
    print("13. User Table")
    print("14. Return to Previous Menu")
    print("15. Exit")
    return colored_input("Select a table to modify (1-15): ", 36)
    
def display_crud_operation_menu(tablename):
    print_colored("\n=== To Modify the Data ===", 34)
    print("1. Add New " + tablename)
    print("2. Read " + tablename + " Data")
    print("3. Update " + tablename + " Data")
    print("4. Delete " + tablename )
    print("5. Return to Previous Menu")
    return colored_input("Enter your choice (1-5): ", 36)

def handle_user_operation():
    choice = display_crud_operation_menu("User")
    # while True:
    if choice == "1":
        # Add New User
        username, email, password, subscriptionID, subscription_duration = input("Enter username: "), input("Enter email: "), input("Enter password: "), input("Enter subscriptionID: "), input("ENter subscription_Duration")
        query = "INSERT INTO User (Username, Email, Password, SubscriptionID, Subscription_Duration) VALUES (%s, %s, %s, %s, %s)"
        execute_query(conn, query, (username, email, password, subscriptionID, subscription_duration))
        print_colored("User added successfully.", 32)

    elif choice == "2":
        # Read User Data
        username = input("Enter username to search: ")
        query = "SELECT * FROM User WHERE Username = %s"
        results = execute_query(conn, query, (username,))
        print_colored("User Read successfully.", 32)
        for row in results:
            print(row)

    elif choice == "3":
        # Update User Data
        userid, new_username, new_email = input("Enter user ID to update: "), input("Enter new username: "), input("Enter new email: ")
        query = "UPDATE User SET Username = %s, Email = %s WHERE UserID = %s"
        execute_query(conn, query, (new_username, new_email, userid))
        print_colored("User updated successfully.", 32)

    elif choice == "4":
        # Delete User
        userid = input("Enter user ID to delete: ")
        query = "DELETE FROM User WHERE UserID = %s"
        execute_query(conn, query, (userid,))
        print_colored("User deleted successfully.", 32)

    elif choice == "5":
        return display_table_list()
    else:
        print("Invalid choice, please choose again.") 
        choice = display_crud_operation_menu("User")

def handle_song_operation(conn):
    choice = display_crud_operation_menu("Song")
    # while True:
    if choice == "1":
        # Add New Song
        songtitle, duration, releaseyear = input("Enter song title: "), input("Enter duration (mm:ss): "), input("Enter release year: ")
        query = "INSERT INTO songs (songtitle, duration, releaseyear) VALUES (%s, %s, %s)"
        execute_query(conn, query, (songtitle, duration, releaseyear))
        print_colored("Song added successfully.", 32)

    elif choice == "2":
        # Read Song Data
        songtitle = input("Enter song title to search: ")
        query = "SELECT * FROM songs WHERE songtitle = %s"
        results = execute_query(conn, query, (songtitle,))
        print_colored("Song data retrieved successfully.", 32)
        for row in results:
            print(row)

    elif choice == "3":
        # Update Song Data
        song_id = input("Enter song ID for update: ")
        new_songtitle, new_duration, new_releaseyear = input("Enter new song title: "), input("Enter new duration (mm:ss): "), input("Enter new release year: ")
        query = "UPDATE songs SET songtitle = %s, duration = %s, releaseyear = %s WHERE SongID = %s"
        execute_query(conn, query, (new_songtitle, new_duration, new_releaseyear, song_id))
        print_colored("Song updated successfully.", 32)

    elif choice == "4":
        # Delete Song
        song_id = input("Enter song ID to delete: ")
        query = "DELETE FROM songs WHERE SongID = %s"
        execute_query(conn, query, (song_id,))
        print_colored("Song deleted successfully.", 32)

    elif choice == "5":
        return display_table_list()
    else:
        print("Invalid choice, please choose again.")
        choice = display_crud_operation_menu("Song")

def handle_playlist_operation(conn):
    choice = display_crud_operation_menu("Playlist")
    # while True:
    if choice == "1":
        # Add New Playlist
        playlist_title, user_id = input("Enter playlist title: "), input("Enter user ID: ")
        query = "INSERT INTO Playlist (PlaylistTitle, UserID) VALUES (%s, %s)"
        execute_query(conn, query, (playlist_title, user_id))
        print_colored("Playlist added successfully.", 32)

    elif choice == "2":
        # Read Playlist Data
        playlist_id = input("Enter playlist ID to search: ")
        query = "SELECT * FROM Playlist WHERE PlaylistID = %s"
        results = execute_query(conn, query, (playlist_id,))
        print_colored("Playlist data retrieved successfully.", 32)
        for row in results:
            print(row)

    elif choice == "3":
        # Update Playlist Data
        playlist_id = input("Enter playlist ID for update: ")
        new_title = input("Enter new playlist title: ")
        query = "UPDATE Playlist SET PlaylistTitle = %s WHERE PlaylistID = %s"
        execute_query(conn, query, (new_title, playlist_id))
        print_colored("Playlist updated successfully.", 32)

    elif choice == "4":
        # Delete Playlist
        playlist_id = input("Enter playlist ID to delete: ")
        query = "DELETE FROM Playlist WHERE PlaylistID = %s"
        execute_query(conn, query, (playlist_id,))
        print_colored("Playlist deleted successfully.", 32)

    elif choice == "5":
        return display_table_list()
    else:
        print("Invalid choice, please choose again.")
        choice = display_crud_operation_menu("Playlist")

def handle_song_playlist_operation(conn):
    choice = display_crud_operation_menu("SongPlaylist")
    # while True:
    if choice == "1":
        # Add New Song-Playlist Association
        song_id, playlist_id = input("Enter song ID: "), input("Enter playlist ID: ")
        query = "INSERT INTO SongPlaylist (SongID, PlaylistID) VALUES (%s, %s)"
        execute_query(conn, query, (song_id, playlist_id))
        print_colored("Song-Playlist association added successfully.", 32)

    elif choice == "2":
        # Read Song-Playlist Data
        playlist_id = input("Enter playlist ID to search: ")
        query = "SELECT * FROM SongPlaylist WHERE PlaylistID = %s"
        results = execute_query(conn, query, (playlist_id,))
        print_colored("Song-Playlist association retrieved successfully.", 32)
        for row in results:
            print(row)

    elif choice == "3":
        # Update Song-Playlist Data
        song_id = input("Enter song ID for the association to update: ")
        new_playlist_id = input("Enter new playlist ID for this song: ")
        query = "UPDATE SongPlaylist SET PlaylistID = %s WHERE SongID = %s"
        execute_query(conn, query, (new_playlist_id, song_id))
        print_colored("Song-Playlist association updated successfully.", 32)

    elif choice == "4":
        # Delete Song-Playlist Association
        song_id, playlist_id = input("Enter song ID to delete: "), input("Enter playlist ID to delete: ")
        query = "DELETE FROM SongPlaylist WHERE SongID = %s AND PlaylistID = %s"
        execute_query(conn, query, (song_id, playlist_id))
        print_colored("Song-Playlist association deleted successfully.", 32)

    elif choice == "5":
        return display_table_list()
    else:
        print("Invalid choice, please choose again.")
        choice = display_crud_operation_menu("SongPlaylist")

def handle_artist_operation(conn):
    choice = display_crud_operation_menu("Artist")
    # while True:
    if choice == "1":
        # Add New Artist
        artist_name = input("Enter artist name: ")
        query = "INSERT INTO Artist (ArtistName) VALUES (%s)"
        execute_query(conn, query, (artist_name,))
        print_colored("Artist added successfully.", 32)

    elif choice == "2":
        # Read Artist Data
        artist_id = input("Enter artist ID to search: ")
        query = "SELECT * FROM Artist WHERE ArtistID = %s"
        results = execute_query(conn, query, (artist_id,))
        print_colored("Artist data retrieved successfully.", 32)
        for row in results:
            print(row)

    elif choice == "3":
        # Update Artist Data
        artist_id = input("Enter artist ID for update: ")
        new_artist_name = input("Enter new artist name: ")
        query = "UPDATE Artist SET ArtistName = %s WHERE ArtistID = %s"
        execute_query(conn, query, (new_artist_name, artist_id))
        print_colored("Artist updated successfully.", 32)

    elif choice == "4":
        # Delete Artist
        artist_id = input("Enter artist ID to delete: ")
        query = "DELETE FROM Artist WHERE ArtistID = %s"
        execute_query(conn, query, (artist_id,))
        print_colored("Artist deleted successfully.", 32)

    elif choice == "5":
        return display_table_list()
    else:
        print("Invalid choice, please choose again.")
        choice = display_crud_operation_menu("Artist")

def handle_song_artist_operation(conn):
    choice = display_crud_operation_menu("SongArtist")
    # while True:
    if choice == "1":
        # Add New Song-Artist Association
        song_id, artist_id = input("Enter song ID: "), input("Enter artist ID: ")
        query = "INSERT INTO SongArtist (SongID, ArtistID) VALUES (%s, %s)"
        execute_query(conn, query, (song_id, artist_id))
        print_colored("Song-Artist association added successfully.", 32)

    elif choice == "2":
        # Read Song-Artist Data
        song_id = input("Enter song ID to search: ")
        query = "SELECT * FROM SongArtist WHERE SongID = %s"
        results = execute_query(conn, query, (song_id,))
        print_colored("Song-Artist association retrieved successfully.", 32)
        for row in results:
            print(row)

    elif choice == "3":
        # Update Song-Artist Data
        song_id = input("Enter song ID for the association to update: ")
        new_artist_id = input("Enter new artist ID for this song: ")
        query = "UPDATE SongArtist SET ArtistID = %s WHERE SongID = %s"
        execute_query(conn, query, (new_artist_id, song_id))
        print_colored("Song-Artist association updated successfully.", 32)

    elif choice == "4":
        # Delete Song-Artist Association
        song_id, artist_id = input("Enter song ID to delete: "), input("Enter artist ID to delete: ")
        query = "DELETE FROM SongArtist WHERE SongID = %s AND ArtistID = %s"
        execute_query(conn, query, (song_id, artist_id))
        print_colored("Song-Artist association deleted successfully.", 32)

    elif choice == "5":
        return display_table_list()
    else:
        print("Invalid choice, please choose again.")
        choice = display_crud_operation_menu("SongArtist")

def handle_album_operation(conn):
    choice = display_crud_operation_menu("Album")
    # while True:
    if choice == "1":
        # Add New Album
        album_title, release_year = input("Enter album title: "), input("Enter release year: ")
        query = "INSERT INTO Album (AlbumTitle, ReleaseYear) VALUES (%s, %s)"
        execute_query(conn, query, (album_title, release_year))
        print_colored("Album added successfully.", 32)

    elif choice == "2":
        # Read Album Data
        album_id = input("Enter album ID to search: ")
        query = "SELECT * FROM Album WHERE AlbumID = %s"
        results = execute_query(conn, query, (album_id,))
        print_colored("Album data retrieved successfully.", 32)
        for row in results:
            print(row)

    elif choice == "3":
        # Update Album Data
        album_id = input("Enter album ID to update: ")
        new_album_title, new_release_year = input("Enter new album title: "), input("Enter new release year: ")
        query = "UPDATE Album SET AlbumTitle = %s, ReleaseYear = %s WHERE AlbumID = %s"
        execute_query(conn, query, (new_album_title, new_release_year, album_id))
        print_colored("Album updated successfully.", 32)

    elif choice == "4":
        # Delete Album
        album_id = input("Enter album ID to delete: ")
        query = "DELETE FROM Album WHERE AlbumID = %s"
        execute_query(conn, query, (album_id,))
        print_colored("Album deleted successfully.", 32)

    elif choice == "5":
        return display_table_list()
    else:
        print("Invalid choice, please choose again.")
        choice = display_crud_operation_menu("Album")

def handle_song_album_operation(conn):
    choice = display_crud_operation_menu("SongAlbum")
    # while True:
    if choice == "1":
        # Add New Song-Album Association
        song_id, album_id = input("Enter song ID: "), input("Enter album ID: ")
        query = "INSERT INTO SongAlbum (SongID, AlbumID) VALUES (%s, %s)"
        execute_query(conn, query, (song_id, album_id))
        print_colored("Song-Album association added successfully.", 32)

    elif choice == "2":
        # Read Song-Album Data
        song_id = input("Enter song ID to search: ")
        query = "SELECT * FROM SongAlbum WHERE SongID = %s"
        results = execute_query(conn, query, (song_id,))
        print_colored("Song-Album association retrieved successfully.", 32)
        for row in results:
            print(row)

    elif choice == "3":
        # Update Song-Album Data
        song_id = input("Enter song ID for the association to update: ")
        new_album_id = input("Enter new album ID for this song: ")
        query = "UPDATE SongAlbum SET AlbumID = %s WHERE SongID = %s"
        execute_query(conn, query, (new_album_id, song_id))
        print_colored("Song-Album association updated successfully.", 32)

    elif choice == "4":
        # Delete Song-Album Association
        song_id, album_id = input("Enter song ID to delete: "), input("Enter album ID to delete: ")
        query = "DELETE FROM SongAlbum WHERE SongID = %s AND AlbumID = %s"
        execute_query(conn, query, (song_id, album_id))
        print_colored("Song-Album association deleted successfully.", 32)

    elif choice == "5":
        return display_table_list()
    else:
        print("Invalid choice, please choose again.")
        choice = display_crud_operation_menu("SongAlbum")

def handle_genre_operation(conn):
    choice = display_crud_operation_menu("Genre")
    # while True:
    if choice == "1":
        # Add New Genre
        genre_name = input("Enter genre name: ")
        query = "INSERT INTO Genre (GenreName) VALUES (%s)"
        execute_query(conn, query, (genre_name,))
        print_colored("Genre added successfully.", 32)

    elif choice == "2":
        # Read Genre Data
        genre_id = input("Enter genre ID to search: ")
        query = "SELECT * FROM Genre WHERE GenreID = %s"
        results = execute_query(conn, query, (genre_id,))
        print_colored("Genre data retrieved successfully.", 32)
        for row in results:
            print(row)

    elif choice == "3":
        # Update Genre Data
        genre_id = input("Enter genre ID to update: ")
        new_genre_name = input("Enter new genre name: ")
        query = "UPDATE Genre SET GenreName = %s WHERE GenreID = %s"
        execute_query(conn, query, (new_genre_name, genre_id))
        print_colored("Genre updated successfully.", 32)

    elif choice == "4":
        # Delete Genre
        genre_id = input("Enter genre ID to delete: ")
        query = "DELETE FROM Genre WHERE GenreID = %s"
        execute_query(conn, query, (genre_id,))
        print_colored("Genre deleted successfully.", 32)

    elif choice == "5":
        return display_table_list()
    else:
        print("Invalid choice, please choose again.")
        choice = display_crud_operation_menu("Genre")
            
def handle_song_genre_operation(conn):
    choice = display_crud_operation_menu("SongGenre")
    # while True:
    if choice == "1":
        # Add New Song-Genre Association
        song_id, genre_id = input("Enter song ID: "), input("Enter genre ID: ")
        query = "INSERT INTO SongGenre (SongID, GenreID) VALUES (%s, %s)"
        execute_query(conn, query, (song_id, genre_id))
        print_colored("Song-Genre association added successfully.", 32)

    elif choice == "2":
        # Read Song-Genre Data
        song_id = input("Enter song ID to search: ")
        query = "SELECT * FROM SongGenre WHERE SongID = %s"
        results = execute_query(conn, query, (song_id,))
        print_colored("Song-Genre association retrieved successfully.", 32)
        for row in results:
            print(row)

    elif choice == "3":
        # Update Song-Genre Data
        song_id = input("Enter song ID for the association to update: ")
        new_genre_id = input("Enter new genre ID for this song: ")
        query = "UPDATE SongGenre SET GenreID = %s WHERE SongID = %s"
        execute_query(conn, query, (new_genre_id, song_id))
        print_colored("Song-Genre association updated successfully.", 32)

    elif choice == "4":
        # Delete Song-Genre Association
        song_id, genre_id = input("Enter song ID to delete: "), input("Enter genre ID to delete: ")
        query = "DELETE FROM SongGenre WHERE SongID = %s AND GenreID = %s"
        execute_query(conn, query, (song_id, genre_id))
        print_colored("Song-Genre association deleted successfully.", 32)

    elif choice == "5":
        return display_table_list()
    else:
        print("Invalid choice, please choose again.")
        choice = display_crud_operation_menu("SongGenre")

def handle_album_genre_operation(conn):
    choice = display_crud_operation_menu("AlbumGenre")
    # while True:
    if choice == "1":
        # Add New Album-Genre Association
        album_id, genre_id = input("Enter album ID: "), input("Enter genre ID: ")
        query = "INSERT INTO AlbumGenre (AlbumID, GenreID) VALUES (%s, %s)"
        execute_query(conn, query, (album_id, genre_id))
        print_colored("Album-Genre association added successfully.", 32)

    elif choice == "2":
        # Read Album-Genre Data
        album_id = input("Enter album ID to search: ")
        query = "SELECT * FROM AlbumGenre WHERE AlbumID = %s"
        results = execute_query(conn, query, (album_id,))
        print_colored("Album-Genre association retrieved successfully.", 32)
        for row in results:
            print(row)

    elif choice == "3":
        # Update Album-Genre Data
        album_id = input("Enter album ID for the association to update: ")
        new_genre_id = input("Enter new genre ID for this album: ")
        query = "UPDATE AlbumGenre SET GenreID = %s WHERE AlbumID = %s"
        execute_query(conn, query, (new_genre_id, album_id))
        print_colored("Album-Genre association updated successfully.", 32)

    elif choice == "4":
        # Delete Album-Genre Association
        album_id, genre_id = input("Enter album ID to delete: "), input("Enter genre ID to delete: ")
        query = "DELETE FROM AlbumGenre WHERE AlbumID = %s AND GenreID = %s"
        execute_query(conn, query, (album_id, genre_id))
        print_colored("Album-Genre association deleted successfully.", 32)

    elif choice == "5":
        return display_table_list()
    else:
        print("Invalid choice, please choose again.")
        choice = display_crud_operation_menu("AlbumGenre")

def handle_artist_album_operation(conn):
    choice = display_crud_operation_menu("ArtistAlbum")
    # while True:
    if choice == "1":
        # Add New Artist-Album Association
        artist_id, album_id = input("Enter artist ID: "), input("Enter album ID: ")
        query = "INSERT INTO ArtistAlbum (ArtistID, AlbumID) VALUES (%s, %s)"
        execute_query(conn, query, (artist_id, album_id))
        print_colored("Artist-Album association added successfully.", 32)

    elif choice == "2":
        # Read Artist-Album Data
        artist_id = input("Enter artist ID to search: ")
        query = "SELECT * FROM ArtistAlbum WHERE ArtistID = %s"
        results = execute_query(conn, query, (artist_id,))
        print_colored("Artist-Album association retrieved successfully.", 32)
        for row in results:
            print(row)

    elif choice == "3":
        # Update Artist-Album Data
        artist_id = input("Enter artist ID for the association to update: ")
        new_album_id = input("Enter new album ID for this artist: ")
        query = "UPDATE ArtistAlbum SET AlbumID = %s WHERE ArtistID = %s"
        execute_query(conn, query, (new_album_id, artist_id))
        print_colored("Artist-Album association updated successfully.", 32)

    elif choice == "4":
        # Delete Artist-Album Association
        artist_id, album_id = input("Enter artist ID to delete: "), input("Enter album ID to delete: ")
        query = "DELETE FROM ArtistAlbum WHERE ArtistID = %s AND AlbumID = %s"
        execute_query(conn, query, (artist_id, album_id))
        print_colored("Artist-Album association deleted successfully.", 32)

    elif choice == "5":
        return display_table_list()
    else:
        print("Invalid choice, please choose again.")
        choice = display_crud_operation_menu("ArtistAlbum")

def handle_subscription_operation(conn):
    choice = display_crud_operation_menu("Subscription")
    # while True:
    if choice == "1":
        # Add New Subscription
        subscription_type, price = input("Enter subscription type: "), input("Enter price: ")
        query = "INSERT INTO Subscription (SubscriptionType, Price) VALUES (%s, %s)"
        execute_query(conn, query, (subscription_type, price))
        print_colored("Subscription added successfully.", 32)

    elif choice == "2":
        # Read Subscription Data
        subscription_id = input("Enter subscription ID to search: ")
        query = "SELECT * FROM Subscription WHERE SubscriptionID = %s"
        results = execute_query(conn, query, (subscription_id,))
        print_colored("Subscription data retrieved successfully.", 32)
        for row in results:
            print(row)

    elif choice == "3":
        # Update Subscription Data
        subscription_id = input("Enter subscription ID to update: ")
        new_subscription_type, new_price = input("Enter new subscription type: "), input("Enter new price: ")
        query = "UPDATE Subscription SET SubscriptionType = %s, Price = %s WHERE SubscriptionID = %s"
        execute_query(conn, query, (new_subscription_type, new_price, subscription_id))
        print_colored("Subscription updated successfully.", 32)

    elif choice == "4":
        # Delete Subscription
        subscription_id = input("Enter subscription ID to delete: ")
        query = "DELETE FROM Subscription WHERE SubscriptionID = %s"
        execute_query(conn, query, (subscription_id,))
        print_colored("Subscription deleted successfully.", 32)

    elif choice == "5":
        return display_table_list()
    else:
        print("Invalid choice, please choose again.")
        choice = display_crud_operation_menu("Subscription")

if __name__ == "__main__":
    conn = create_connection()
    if conn:
        main_menu(conn)
        conn.close()
    else:
        print("Unable to connect to the database.")