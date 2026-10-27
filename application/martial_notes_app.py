# Team 20: Fatima Rizvi and Michael Yanez
# Citation for use of AI Tools
# Date: 10/27/2026
# The prompt used to generate this code is in the file "Proj-Step-3-Init-Python-App.md"
# in this repo's "prompts" folder. The prompt used SQL queries that were written
# without AI, and the SQL queries are available in the "martial_notes_dml.sql"
# and "martial_notes_ddl.sql" files in this repo's "SQL" folder.

"""Application-tier queries for managing the Martial Notes database."""

import mysql.connector


class MartialNotesQueries(object):
    """Encapsulates CRUD and read operations for the Martial Notes schema."""

    def __init__(self, cursor, connection=None):
        """Store the database cursor and optional connection for commit support."""
        self.cursor = cursor
        self.connection = connection

    def _commit(self):
        """Commit the current transaction if a connection was provided."""
        if self.connection is not None:
            self.connection.commit()

    def get_all_martial_arts(self):
        """Return every record from the MartialArts table."""
        sql = "SELECT * FROM MartialArts;"
        self.cursor.execute(sql)
        return self.cursor.fetchall()

    def get_martial_art_by_id(self, martial_art_id):
        """Return a single martial art record by its primary key."""
        sql = "SELECT * FROM MartialArts WHERE martialArtID = %s;"
        self.cursor.execute(sql, (martial_art_id,))
        return self.cursor.fetchone()

    def get_all_moves(self):
        """Return every record from the Moves table."""
        sql = "SELECT * FROM Moves;"
        self.cursor.execute(sql)
        return self.cursor.fetchall()

    def get_move_by_id(self, move_id):
        """Return a single move record by its primary key."""
        sql = "SELECT * FROM Moves WHERE moveID = %s;"
        self.cursor.execute(sql, (move_id,))
        return self.cursor.fetchone()

    def get_moves_for_martial_art(self, martial_art_id):
        """Return all move names and descriptions for a given martial art."""
        sql = """
            SELECT Moves.name, description
            FROM Moves
            INNER JOIN MartialArtMoves 
            ON Moves.moveID = MartialArtMoves.moveID
            INNER JOIN MartialArts 
            ON MartialArtMoves.martialArtID = MartialArts.martialArtID
            WHERE MartialArts.martialArtID = %s;
        """
        self.cursor.execute(sql, (martial_art_id,))
        return self.cursor.fetchall()

    def get_all_martial_art_moves(self):
        """Return every relationship in the MartialArtMoves table."""
        sql = "SELECT * FROM MartialArtMoves;"
        self.cursor.execute(sql)
        return self.cursor.fetchall()

    def get_martial_art_move_by_id(self, martial_art_id, move_id):
        """Return a single MartialArtMoves row by the composite key."""
        sql = """
            SELECT *
            FROM MartialArtMoves
            WHERE martialArtID = %s AND moveID = %s;
        """
        self.cursor.execute(sql, (martial_art_id, move_id))
        return self.cursor.fetchone()

    def get_martial_art_move_details(self, martial_art_id, move_id):
        """Return a move's name, martial art type, and description for a relationship."""
        sql = """
            SELECT Moves.name, MartialArts.name AS martial_art_type, Moves.description
            FROM MartialArtMoves
            INNER JOIN Moves 
            ON MartialArtMoves.moveID = Moves.moveID
            INNER JOIN MartialArts 
            ON MartialArtMoves.martialArtID = MartialArts.martialArtID
            WHERE MartialArtMoves.martialArtID = %s
              AND MartialArtMoves.moveID = %s;
        """
        self.cursor.execute(sql, (martial_art_id, move_id))
        return self.cursor.fetchone()

    def get_all_events(self):
        """Return every record from the Events table."""
        sql = "SELECT * FROM Events;"
        self.cursor.execute(sql)
        return self.cursor.fetchall()

    def get_events_for_martial_art(self, martial_art_id):
        """Return every event attached to a specific martial art."""
        sql = "SELECT * FROM Events WHERE martialArtID = %s;"
        self.cursor.execute(sql, (martial_art_id,))
        return self.cursor.fetchall()

    def get_event_by_id(self, event_id):
        """Return a single event record by its primary key."""
        sql = "SELECT * FROM Events WHERE eventID = %s;"
        self.cursor.execute(sql, (event_id,))
        return self.cursor.fetchone()

    def get_all_study_sessions(self):
        """Return every record from the StudySessions table."""
        sql = "SELECT * FROM StudySessions;"
        self.cursor.execute(sql)
        return self.cursor.fetchall()

    def get_study_sessions_for_martial_art(self, martial_art_id):
        """Return every study session attached to a specific martial art."""
        sql = "SELECT * FROM StudySessions WHERE martialArtID = %s;"
        self.cursor.execute(sql, (martial_art_id,))
        return self.cursor.fetchall()

    def get_study_session_by_id(self, study_session_id):
        """Return a single study session record by its primary key."""
        sql = "SELECT * FROM StudySessions WHERE studySessionID = %s;"
        self.cursor.execute(sql, (study_session_id,))
        return self.cursor.fetchone()

    def add_martial_art(self, name):
        """Insert a new martial art and return the row count."""
        sql = "INSERT INTO MartialArts (name) VALUES (%s);"
        self.cursor.execute(sql, (name,))
        return self.cursor.rowcount

    def add_move(self, name, description):
        """Insert a new move and return the row count."""
        sql = "INSERT INTO Moves (name, description) VALUES (%s, %s);"
        self.cursor.execute(sql, (name, description))
        return self.cursor.rowcount

    def add_martial_art_move(self, martial_art_id, move_id):
        """Insert a martial art to move relationship and return the row count."""
        sql = """
            INSERT INTO MartialArtMoves (martialArtID, moveID)
            VALUES (%s, %s);
        """
        self.cursor.execute(sql, (martial_art_id, move_id))
        return self.cursor.rowcount

    def add_event(self, name, date, martial_art_id=None):
        """Insert a new event; martialArtID may be null as defined by the schema."""
        sql = """
            INSERT INTO Events (name, date, martialArtID)
            VALUES (%s, %s, %s);
        """
        self.cursor.execute(sql, (name, date, martial_art_id))
        return self.cursor.rowcount

    def add_study_session(self, date, duration, martial_art_id, event_id=None):
        """Insert a study session; eventID may be null as defined by the schema."""
        sql = """
            INSERT INTO StudySessions (date, duration, martialArtID, eventID)
            VALUES (%s, %s, %s, %s);
        """
        self.cursor.execute(sql, (date, duration, martial_art_id, event_id))
        return self.cursor.rowcount

    def update_martial_art_move(self, original_martial_art_id, original_move_id,
                               new_martial_art_id, new_move_id):
        """Update a MartialArtMoves relationship by its original composite key."""
        sql = """
            UPDATE MartialArtMoves
            SET martialArtID = %s, moveID = %s
            WHERE martialArtID = %s AND moveID = %s;
        """
        self.cursor.execute(
            sql,
            (new_martial_art_id, new_move_id, original_martial_art_id, original_move_id),
        )
        return self.cursor.rowcount

    def update_move(self, move_id, name, description):
        """Update a move record by its primary key and return the row count."""
        sql = """
            UPDATE Moves
            SET name = %s, description = %s
            WHERE moveID = %s;
        """
        self.cursor.execute(sql, (name, description, move_id))
        return self.cursor.rowcount

    def delete_martial_art_move(self, martial_art_id, move_id):
        """Delete one MartialArtMoves relationship and return the row count."""
        sql = """
            DELETE FROM MartialArtMoves
            WHERE martialArtID = %s AND moveID = %s;
        """
        self.cursor.execute(sql, (martial_art_id, move_id))
        return self.cursor.rowcount

    def delete_event(self, event_id):
        """Delete one event record and return the row count."""
        sql = "DELETE FROM Events WHERE eventID = %s;"
        self.cursor.execute(sql, (event_id,))
        return self.cursor.rowcount
