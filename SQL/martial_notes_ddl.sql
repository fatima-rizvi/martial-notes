-- Team 20: Fatima Rizvi and Michael Yanez
-- Citation for use of AI Tools
-- Date: 11/11/2026
-- The prompt used to modify this code (and replace the SQL with PL/SQL) from it's step 3 version is in the file "Proj-Step-4-Update-to-PL-and-SQL.md" in this repo's "prompts" folder, and it was used by Github CoPilot. After the initial generation, the code was reviewed and updated by us for correctness.
-- All other work below is our own, aside from the recommended disabling and re-enabling of commits and foreign key checks which were suggested in the CS340 Project Step 2 Draft assignment instructions.
 
-- Disabling commits and foreign key checks to minimize import errors
SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;
START TRANSACTION;

-- Creating our 5 tables (4 entities and 1 intersection table)
DROP TABLE IF EXISTS MartialArts;

CREATE TABLE MartialArts (
    martialArtID int NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL,
    PRIMARY KEY (martialArtID)
);

DROP TABLE IF EXISTS Moves;

CREATE TABLE Moves (
    moveID int NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL,
    description text NOT NULL,
    PRIMARY KEY (moveID)
);

DROP TABLE IF EXISTS MartialArtMoves;

CREATE TABLE MartialArtMoves (
    martialArtID int NOT NULL,
    moveID int NOT NULL,
    PRIMARY KEY (martialArtID, moveID),
    FOREIGN KEY (martialArtID) REFERENCES MartialArts(martialArtID) ON DELETE CASCADE,
    FOREIGN KEY (moveID) REFERENCES Moves(moveID) ON DELETE CASCADE
);

DROP TABLE IF EXISTS Events;

CREATE TABLE Events (
    eventID int AUTO_INCREMENT,
    name varchar(100) NOT NULL,
    date datetime NOT NULL,
    martialArtID int, 
    PRIMARY KEY (eventID),
    FOREIGN KEY (martialArtID) REFERENCES MartialArts(martialArtID) ON DELETE SET NULL
);

DROP TABLE IF EXISTS StudySessions;

CREATE TABLE StudySessions (
    studySessionID int AUTO_INCREMENT,
    date datetime NOT NULL,
    duration time NOT NULL,
    martialArtID int NOT NULL, 
    eventID int, 
    PRIMARY KEY (studySessionID),
    FOREIGN KEY (martialArtID) REFERENCES MartialArts(martialArtID) ON DELETE CASCADE,
    FOREIGN KEY (eventID) REFERENCES Events(eventID) ON DELETE SET NULL
);

-- The create procedures must be installed before running this DDL script.
CALL sp_CreateMartialArt('Muay Thai', @martialArtID);
CALL sp_CreateMartialArt('Jiu Jitsu', @martialArtID);
CALL sp_CreateMartialArt('MMA', @martialArtID);

CALL sp_CreateMove('Jab', 'A straight punch with your lead hand', @moveID);
CALL sp_CreateMove(
    'Parallel Elbow Strike',
    'Swing your elbow at your opponent, keeping your strike parallel to the ground. Aim to hit your opponent''s head in their jaw, temple, or chin. This does not need a lot of force behind it to be effective.',
    @moveID
);
CALL sp_CreateMove(
    'Shrimping',
    'A hip escape. Practice by starting on laying on your back, knees bent and feet planted on the ground. Bridge your hips up and roll onto one of your shoulders. Use your foot (same side as the shoulder you are laying on) to push your body and slide your hips back while you pivot on your shoulder. Your body should curve (like a shrimp). Reset your body and repeat the movement on the other side. You should be able to move all the way down the mat like this. This is a good way to escape an opponent standing over you without giving them more openings. ',
    @moveID
);

SET @martialArtID = (SELECT martialArtID FROM MartialArts WHERE name = 'Muay Thai');
SET @moveID = (SELECT moveID FROM Moves WHERE name = 'Jab');
CALL sp_CreateMartialArtMove(@martialArtID, @moveID, @created);

SET @martialArtID = (SELECT martialArtID FROM MartialArts WHERE name = 'MMA');
CALL sp_CreateMartialArtMove(@martialArtID, @moveID, @created);

SET @martialArtID = (SELECT martialArtID FROM MartialArts WHERE name = 'Muay Thai');
SET @moveID = (SELECT moveID FROM Moves WHERE name = 'Parallel Elbow Strike');
CALL sp_CreateMartialArtMove(@martialArtID, @moveID, @created);

SET @martialArtID = (SELECT martialArtID FROM MartialArts WHERE name = 'MMA');
CALL sp_CreateMartialArtMove(@martialArtID, @moveID, @created);

SET @martialArtID = (SELECT martialArtID FROM MartialArts WHERE name = 'Jiu Jitsu');
SET @moveID = (SELECT moveID FROM Moves WHERE name = 'Shrimping');
CALL sp_CreateMartialArtMove(@martialArtID, @moveID, @created);

SET @martialArtID = (SELECT martialArtID FROM MartialArts WHERE name = 'Jiu Jitsu');
CALL sp_CreateEvent('BJJ Open', '2026-11-15 00:00:00', @martialArtID, @eventID);

CALL sp_CreateEvent('Gym Open Mat', '2026-12-07 00:00:00', NULL, @eventID);

SET @martialArtID = (SELECT martialArtID FROM MartialArts WHERE name = 'MMA');
CALL sp_CreateEvent('UFC Fight Night', '2026-12-19 00:00:00', @martialArtID, @eventID);

SET @martialArtID = (SELECT martialArtID FROM MartialArts WHERE name = 'Muay Thai');
CALL sp_CreateStudySession('2026-10-03 00:00:00', '01:01:00', @martialArtID, NULL, @studySessionID);

SET @martialArtID = (SELECT martialArtID FROM MartialArts WHERE name = 'Jiu Jitsu');
SET @eventID = (SELECT eventID FROM Events WHERE name = 'BJJ Open');
CALL sp_CreateStudySession('2026-10-05 00:00:00', '00:37:00', @martialArtID, @eventID, @studySessionID);

SET @martialArtID = (SELECT martialArtID FROM MartialArts WHERE name = 'MMA');
SET @eventID = (SELECT eventID FROM Events WHERE name = 'UFC Fight Night');
CALL sp_CreateStudySession('2026-10-07 00:00:00', '00:53:00', @martialArtID, @eventID, @studySessionID);


-- Re-enabling foreign key checks and commiting changes
SET FOREIGN_KEY_CHECKS=1;
COMMIT;