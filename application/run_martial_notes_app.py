# Team 20: Fatima Rizvi and Michael Yanez
# Citation for use of AI Tools
# Date: 10/27/2026
# The prompt used to generate this code is in the file "Proj-Step-3-Init-Python-App.md"
# in this repo's "prompts" folder. The prompt used SQL queries that were written
# without AI, and the SQL queries are available in the "martial_notes_dml.sql"
# file in this repo's "SQL" folder. After the initial generation, the test runner was modified by us without AI to make sure it had all the necessary information for the grader and for anyone else running it.

"""Exercise every MartialNotesQueries method against the configured database."""

import os

import mysql.connector

from martial_notes_app import MartialNotesQueries


def main():
    """Connect to the configured database, exercise the queries, and close."""

    # replace the values below with your own DB information
    conn = mysql.connector.connect(
        host='localhost',
        user='root',
        password='<db password>',
        database='<db name>'
    )
    cursor = conn.cursor()

    q = MartialNotesQueries(cursor, conn)

    print("Select all martial arts:", q.get_all_martial_arts())
    print("Select martial art by ID:", q.get_martial_art_by_id(1))
    print("Select all moves:", q.get_all_moves())
    print("Select move by ID:", q.get_move_by_id(1))
    print("Select moves for martial art:", q.get_moves_for_martial_art(1))
    print("Select all martial art moves:", q.get_all_martial_art_moves())
    print("Select martial art move by ID:", q.get_martial_art_move_by_id(1, 1))
    print("Martial art move details:", q.get_martial_art_move_details(1, 1))
    print("Select all events:", q.get_all_events())
    print("Select events for martial art:", q.get_events_for_martial_art(1))
    print("Select event by ID:", q.get_event_by_id(1))
    print("Select all study sessions:", q.get_all_study_sessions())
    print("Select study sessions for martial art:", q.get_study_sessions_for_martial_art(1))
    print("Select study session by ID:", q.get_study_session_by_id(1))

    row_count = q.add_martial_art("Karate")
    conn.commit()
    print("Add martial art row count:", row_count)
    print("MartialArts table after insert:", q.get_all_martial_arts())

    new_move_name = "Front Kick"
    new_move_description = "A direct kick thrown with the lead leg."
    row_count = q.add_move(new_move_name, new_move_description)
    conn.commit()
    print("Add move row count:", row_count)
    new_move_id = cursor.lastrowid
    print("Moves table after insert:", q.get_all_moves())

    row_count = q.add_martial_art_move(1, new_move_id)
    conn.commit()
    print("Add martial art move row count:", row_count)
    print("MartialArtMoves table after insert:", q.get_all_martial_art_moves())

    row_count = q.add_event("Test Event", "2027-01-15 00:00:00", None)
    conn.commit()
    print("Add event with null martialArtID row count:", row_count)

    row_count = q.add_event("Test Event 2", "2027-01-16 00:00:00", 1)
    conn.commit()
    event_id_to_delete = cursor.lastrowid
    print("Add event with martialArtID row count:", row_count)
    print("Events table after inserts:", q.get_all_events())

    row_count = q.add_study_session("2027-01-17", "00:45:00", 1, None)
    conn.commit()
    print("Add study session with null eventID row count:", row_count)

    row_count = q.add_study_session("2027-01-18", "00:50:00", 1, 1)
    conn.commit()
    print("Add study session with eventID row count:", row_count)
    print("Study sessions table after inserts:", q.get_all_study_sessions())

    row_count = q.update_martial_art_move(1, new_move_id, 2, new_move_id)
    conn.commit()
    print("Update martial art move row count:", row_count)
    print("MartialArtMoves table after update:", q.get_all_martial_art_moves())

    row_count = q.update_move(
        new_move_id,
        "Front Kick",
        "Updated description for the front kick.",
    )
    conn.commit()
    print("Update move row count:", row_count)
    print("Moves table after update:", q.get_all_moves())

    row_count = q.delete_martial_art_move(2, new_move_id)
    conn.commit()
    print("Delete martial art move row count:", row_count)
    print("MartialArtMoves table after delete:", q.get_all_martial_art_moves())

    row_count = q.delete_event(event_id_to_delete)
    conn.commit()
    print("Delete event row count:", row_count)
    print("Events table after delete:", q.get_all_events())

    cursor.close()
    conn.close()

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
