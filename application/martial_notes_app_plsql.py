# Team 20: Fatima Rizvi and Michael Yanez
# PL/SQL-style stored procedure wrapper for the Martial Notes database.
# Citation for use of AI Tools
# Date: 11/11/2026
# The prompt used to generate this code is in the file "Proj-Step-4-Update-to-PL-and-SQL.md" in this repo's "prompts" folder, and it was used by Github CoPilot. After the initial generation, the code was reviewed and updated by us for correctness.

"""Application-tier queries for managing the Martial Notes database via MySQL procedures."""

import mysql.connector


class MartialNotesQueries(object):
    """Encapsulates CRUD and read operations for the Martial Notes schema."""

    def __init__(self, cursor, connection=None):
        """Store the database cursor and optional connection for commit support."""
        self.cursor = cursor
        self.connection = connection
        self.last_inserted_id = None

    def _commit(self):
        """Commit the current transaction if a connection was provided."""
        if self.connection is not None:
            self.connection.commit()

    def _drain_result_sets(self):
        """Drain any pending result sets returned by stored procedure calls."""
        while self.cursor.nextset():
            pass

    def get_all_martial_arts(self):
        """Return every record from the MartialArts table."""
        sql = "SELECT * FROM MartialArts ORDER BY name;"
        self.cursor.execute(sql)
        return self.cursor.fetchall()

    def get_martial_art_by_id(self, martial_art_id):
        """Return a single martial art record by its primary key."""
        sql = "SELECT * FROM MartialArts WHERE martialArtID = %s;"
        self.cursor.execute(sql, (martial_art_id,))
        return self.cursor.fetchone()

    def get_all_moves(self):
        """Return every record from the Moves table."""
        sql = "SELECT * FROM Moves ORDER BY name;"
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
            SELECT Moves.name AS moveName, Moves.description AS moveDescription
            FROM Moves
            INNER JOIN MartialArtMoves 
            ON Moves.moveID = MartialArtMoves.moveID
            INNER JOIN MartialArts 
            ON MartialArtMoves.martialArtID = MartialArts.martialArtID
            WHERE MartialArts.martialArtID = %s
            ORDER BY Moves.name;
        """
        self.cursor.execute(sql, (martial_art_id,))
        return self.cursor.fetchall()

    def get_all_martial_art_moves(self):
        """Return every relationship with martial art and move names."""
        sql = """
            SELECT MartialArtMoves.martialArtID,
                   MartialArtMoves.moveID,
                   MartialArts.name AS martialArtName,
                   Moves.name AS moveName
            FROM MartialArtMoves
            INNER JOIN MartialArts
            ON MartialArtMoves.martialArtID = MartialArts.martialArtID
            INNER JOIN Moves
            ON MartialArtMoves.moveID = Moves.moveID
            ORDER BY MartialArts.name, Moves.name;
        """
        self.cursor.execute(sql)
        return self.cursor.fetchall()

    def get_martial_art_move_by_id(self, martial_art_id, move_id):
        """Return one relationship with its martial art and move names."""
        sql = """
            SELECT MartialArtMoves.martialArtID,
                   MartialArtMoves.moveID,
                   MartialArts.name AS martialArtName,
                   Moves.name AS moveName
            FROM MartialArtMoves
            INNER JOIN MartialArts
            ON MartialArtMoves.martialArtID = MartialArts.martialArtID
            INNER JOIN Moves
            ON MartialArtMoves.moveID = Moves.moveID
            WHERE MartialArtMoves.martialArtID = %s
              AND MartialArtMoves.moveID = %s;
        """
        self.cursor.execute(sql, (martial_art_id, move_id))
        return self.cursor.fetchone()

    def get_martial_art_move_details(self, martial_art_id, move_id):
        """Return a move's name, martial art type, and description for a relationship."""
        sql = """
            SELECT Moves.name AS moveName,
                   MartialArts.name AS martialArtName,
                   Moves.description AS moveDescription
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
        """Return every event with its associated martial art name."""
        sql = """
            SELECT Events.eventID,
                   Events.name AS eventName,
                   Events.date,
                   Events.martialArtID,
                   MartialArts.name AS martialArtName
            FROM Events
            LEFT JOIN MartialArts
            ON Events.martialArtID = MartialArts.martialArtID
            ORDER BY Events.name;
        """
        self.cursor.execute(sql)
        return self.cursor.fetchall()

    def get_events_for_martial_art(self, martial_art_id):
        """Return events for a martial art, including its name."""
        sql = """
            SELECT Events.eventID,
                   Events.name AS eventName,
                   Events.date,
                   Events.martialArtID,
                   MartialArts.name AS martialArtName
            FROM Events
            LEFT JOIN MartialArts
            ON Events.martialArtID = MartialArts.martialArtID
            WHERE Events.martialArtID = %s
            ORDER BY Events.name;
        """
        self.cursor.execute(sql, (martial_art_id,))
        return self.cursor.fetchall()

    def get_event_by_id(self, event_id):
        """Return one event with its associated martial art name."""
        sql = """
            SELECT Events.eventID,
                   Events.name AS eventName,
                   Events.date,
                   Events.martialArtID,
                   MartialArts.name AS martialArtName
            FROM Events
            LEFT JOIN MartialArts
            ON Events.martialArtID = MartialArts.martialArtID
            WHERE Events.eventID = %s;
        """
        self.cursor.execute(sql, (event_id,))
        return self.cursor.fetchone()

    def get_all_study_sessions(self):
        """Return every session with its martial art and optional event names."""
        sql = """
            SELECT StudySessions.studySessionID,
                   StudySessions.date AS sessionDate,
                   StudySessions.duration AS sessionDuration,
                   StudySessions.martialArtID,
                   StudySessions.eventID,
                   MartialArts.name AS martialArtName,
                   Events.name AS eventName
            FROM StudySessions
            INNER JOIN MartialArts
            ON StudySessions.martialArtID = MartialArts.martialArtID
            LEFT JOIN Events
            ON StudySessions.eventID = Events.eventID
            ORDER BY MartialArts.name, Events.name;
        """
        self.cursor.execute(sql)
        return self.cursor.fetchall()

    def get_study_sessions_for_martial_art(self, martial_art_id):
        """Return sessions for a martial art with related names."""
        sql = """
            SELECT StudySessions.studySessionID,
                   StudySessions.date AS sessionDate,
                   StudySessions.duration AS sessionDuration,
                   StudySessions.martialArtID,
                   StudySessions.eventID,
                   MartialArts.name AS martialArtName,
                   Events.name AS eventName
            FROM StudySessions
            INNER JOIN MartialArts
            ON StudySessions.martialArtID = MartialArts.martialArtID
            LEFT JOIN Events
            ON StudySessions.eventID = Events.eventID
            WHERE StudySessions.martialArtID = %s
            ORDER BY MartialArts.name, Events.name;
        """
        self.cursor.execute(sql, (martial_art_id,))
        return self.cursor.fetchall()

    def get_study_session_by_id(self, study_session_id):
        """Return one session with its martial art and optional event names."""
        sql = """
            SELECT StudySessions.studySessionID,
                   StudySessions.date AS sessionDate,
                   StudySessions.duration AS sessionDuration,
                   StudySessions.martialArtID,
                   StudySessions.eventID,
                   MartialArts.name AS martialArtName,
                   Events.name AS eventName
            FROM StudySessions
            INNER JOIN MartialArts
            ON StudySessions.martialArtID = MartialArts.martialArtID
            LEFT JOIN Events
            ON StudySessions.eventID = Events.eventID
            WHERE StudySessions.studySessionID = %s;
        """
        self.cursor.execute(sql, (study_session_id,))
        return self.cursor.fetchone()

    def add_martial_art(self, name):
        """Insert a new martial art and return 1 when successful."""
        sql = "CALL sp_CreateMartialArt(%s, @new_id);"
        self.cursor.execute(sql, (name,))
        self._drain_result_sets()
        self.cursor.execute("SELECT @new_id;")
        new_id = self.cursor.fetchone()[0]
        self.last_inserted_id = new_id
        self._commit()
        return 1 if new_id else 0

    def add_move(self, name, description):
        """Insert a new move and return 1 when successful."""
        sql = "CALL sp_CreateMove(%s, %s, @new_id);"
        self.cursor.execute(sql, (name, description))
        self._drain_result_sets()
        self.cursor.execute("SELECT @new_id;")
        new_id = self.cursor.fetchone()[0]
        self.last_inserted_id = new_id
        self._commit()
        return 1 if new_id else 0

    def add_martial_art_move(self, martial_art_id, move_id):
        """Insert a martial art to move relationship and return 1 when successful."""
        sql = "CALL sp_CreateMartialArtMove(%s, %s, @created);"
        self.cursor.execute(sql, (martial_art_id, move_id))
        self._drain_result_sets()
        self.cursor.execute("SELECT @created;")
        created = self.cursor.fetchone()[0]
        self.last_inserted_id = None
        self._commit()
        return 1 if created else 0

    def add_event(self, name, date, martial_art_id=None):
        """Insert a new event; martialArtID may be null as defined by the schema."""
        sql = "CALL sp_CreateEvent(%s, %s, %s, @new_id);"
        self.cursor.execute(sql, (name, date, martial_art_id))
        self._drain_result_sets()
        self.cursor.execute("SELECT @new_id;")
        new_id = self.cursor.fetchone()[0]
        self.last_inserted_id = new_id
        self._commit()
        return 1 if new_id else 0

    def add_study_session(self, date, duration, martial_art_id, event_id=None):
        """Insert a study session; eventID may be null as defined by the schema."""
        sql = "CALL sp_CreateStudySession(%s, %s, %s, %s, @new_id);"
        self.cursor.execute(sql, (date, duration, martial_art_id, event_id))
        self._drain_result_sets()
        self.cursor.execute("SELECT @new_id;")
        new_id = self.cursor.fetchone()[0]
        self.last_inserted_id = new_id
        self._commit()
        return 1 if new_id else 0

    def update_martial_art_move(self, original_martial_art_id, original_move_id,
                               new_martial_art_id, new_move_id):
        """Update a MartialArtMoves relationship by its original composite key."""
        sql = "CALL sp_UpdateMartialArtMove(%s, %s, %s, %s, @rows_affected);"
        self.cursor.execute(
            sql,
            (original_martial_art_id, original_move_id, new_martial_art_id, new_move_id),
        )
        self._drain_result_sets()
        self.cursor.execute("SELECT @rows_affected;")
        rowcount = self.cursor.fetchone()[0]
        self._commit()
        return rowcount

    def update_move(self, move_id, name, description):
        """Update a move record by its primary key and return the row count."""
        sql = "CALL sp_UpdateMove(%s, %s, %s, @rows_affected);"
        self.cursor.execute(sql, (move_id, name, description))
        self._drain_result_sets()
        self.cursor.execute("SELECT @rows_affected;")
        rowcount = self.cursor.fetchone()[0]
        self._commit()
        return rowcount

    def delete_martial_art_move(self, martial_art_id, move_id):
        """Delete one MartialArtMoves relationship and return the row count."""
        sql = "CALL sp_DeleteMartialArtMove(%s, %s, @rows_deleted);"
        self.cursor.execute(sql, (martial_art_id, move_id))
        self._drain_result_sets()
        self.cursor.execute("SELECT @rows_deleted;")
        rowcount = self.cursor.fetchone()[0]
        self._commit()
        return rowcount

    def delete_event(self, event_id):
        """Delete one event record and return the row count."""
        sql = "CALL sp_DeleteEvent(%s, @rows_deleted);"
        self.cursor.execute(sql, (event_id,))
        self._drain_result_sets()
        self.cursor.execute("SELECT @rows_deleted;")
        rowcount = self.cursor.fetchone()[0]
        self._commit()
        return rowcount

    def reset_database(self):
        """Reset the schema and sample data back to the original state."""
        self.cursor.execute("CALL sp_ResetMartialNotesDatabase();")
        self._drain_result_sets()
        self._commit()
        return 1
