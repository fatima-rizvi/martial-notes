-- Team 20: Fatima Rizvi and Michael Yanez
-- Stored procedures for reset, create, update, and delete operations.
-- Citation for use of AI Tools
-- Date: 11/11/2026
-- The prompt used to generate this code is in the file "Proj-Step-4-Update-to-PL-and-SQL.md" in this repo's "prompts" folder, and it was used by Github CoPilot. After the initial generation, the code was reviewed and updated by us for correctness.

DROP PROCEDURE IF EXISTS sp_CreateMartialArt;
DELIMITER //
CREATE PROCEDURE sp_CreateMartialArt(
    IN p_name VARCHAR(100),
    OUT p_martialArtID INT
)
BEGIN
    INSERT INTO MartialArts (name)
    VALUES (p_name);

    SELECT LAST_INSERT_ID() INTO p_martialArtID;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_CreateMove;
DELIMITER //
CREATE PROCEDURE sp_CreateMove(
    IN p_name VARCHAR(100),
    IN p_description TEXT,
    OUT p_moveID INT
)
BEGIN
    INSERT INTO Moves (name, description)
    VALUES (p_name, p_description);

    SELECT LAST_INSERT_ID() INTO p_moveID;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_CreateMartialArtMove;
DELIMITER //
CREATE PROCEDURE sp_CreateMartialArtMove(
    IN p_martialArtID INT,
    IN p_moveID INT,
    OUT p_created INT
)
BEGIN
    INSERT INTO MartialArtMoves (martialArtID, moveID)
    VALUES (p_martialArtID, p_moveID);

    SET p_created = ROW_COUNT();
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_CreateEvent;
DELIMITER //
CREATE PROCEDURE sp_CreateEvent(
    IN p_name VARCHAR(100),
    IN p_date DATETIME,
    IN p_martialArtID INT,
    OUT p_eventID INT
)
BEGIN
    INSERT INTO Events (name, date, martialArtID)
    VALUES (p_name, p_date, p_martialArtID);

    SELECT LAST_INSERT_ID() INTO p_eventID;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_CreateStudySession;
DELIMITER //
CREATE PROCEDURE sp_CreateStudySession(
    IN p_date DATETIME,
    IN p_duration TIME,
    IN p_martialArtID INT,
    IN p_eventID INT,
    OUT p_studySessionID INT
)
BEGIN
    INSERT INTO StudySessions (date, duration, martialArtID, eventID)
    VALUES (p_date, p_duration, p_martialArtID, p_eventID);

    SELECT LAST_INSERT_ID() INTO p_studySessionID;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_UpdateMartialArtMove;
DELIMITER //
CREATE PROCEDURE sp_UpdateMartialArtMove(
    IN p_originalMartialArtID INT,
    IN p_originalMoveID INT,
    IN p_newMartialArtID INT,
    IN p_newMoveID INT,
    OUT p_rows_affected INT
)
BEGIN
    UPDATE MartialArtMoves
    SET martialArtID = p_newMartialArtID,
        moveID = p_newMoveID
    WHERE martialArtID = p_originalMartialArtID
      AND moveID = p_originalMoveID;

    SET p_rows_affected = ROW_COUNT();
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_UpdateMove;
DELIMITER //
CREATE PROCEDURE sp_UpdateMove(
    IN p_moveID INT,
    IN p_name VARCHAR(100),
    IN p_description TEXT,
    OUT p_rows_affected INT
)
BEGIN
    UPDATE Moves
    SET name = p_name,
        description = p_description
    WHERE moveID = p_moveID;

    SET p_rows_affected = ROW_COUNT();
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_DeleteMartialArtMove;
DELIMITER //
CREATE PROCEDURE sp_DeleteMartialArtMove(
    IN p_martialArtID INT,
    IN p_moveID INT,
    OUT p_rows_deleted INT
)
BEGIN
    DECLARE v_rows_deleted INT DEFAULT 0;
    DECLARE error_message VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    DELETE FROM MartialArtMoves
    WHERE martialArtID = p_martialArtID
      AND moveID = p_moveID;

    SET v_rows_deleted = ROW_COUNT();

    IF v_rows_deleted = 0 THEN
        SET error_message = CONCAT(
            'No matching record found in MartialArtMoves for martialArtID: ',
            p_martialArtID,
            ', moveID: ',
            p_moveID
        );
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;

    SET p_rows_deleted = v_rows_deleted;
    COMMIT;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_DeleteEvent;
DELIMITER //
CREATE PROCEDURE sp_DeleteEvent(
    IN p_eventID INT,
    OUT p_rows_deleted INT
)
BEGIN
    DECLARE v_rows_deleted INT DEFAULT 0;
    DECLARE error_message VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    DELETE FROM Events
    WHERE eventID = p_eventID;

    SET v_rows_deleted = ROW_COUNT();

    IF v_rows_deleted = 0 THEN
        SET error_message = CONCAT('No matching record found in Events for eventID: ', p_eventID);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;

    SET p_rows_deleted = v_rows_deleted;
    COMMIT;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ResetMartialNotesDatabase;
DELIMITER //
CREATE PROCEDURE sp_ResetMartialNotesDatabase()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET FOREIGN_KEY_CHECKS = 1;
        RESIGNAL;
    END;

    SET FOREIGN_KEY_CHECKS = 0;

    DROP TABLE IF EXISTS StudySessions;
    DROP TABLE IF EXISTS Events;
    DROP TABLE IF EXISTS MartialArtMoves;
    DROP TABLE IF EXISTS Moves;
    DROP TABLE IF EXISTS MartialArts;

    CREATE TABLE MartialArts (
        martialArtID int NOT NULL AUTO_INCREMENT,
        name varchar(100) NOT NULL,
        PRIMARY KEY (martialArtID)
    );

    CREATE TABLE Moves (
        moveID int NOT NULL AUTO_INCREMENT,
        name varchar(100) NOT NULL,
        description text NOT NULL,
        PRIMARY KEY (moveID)
    );

    CREATE TABLE MartialArtMoves (
        martialArtID int NOT NULL,
        moveID int NOT NULL,
        PRIMARY KEY (martialArtID, moveID),
        FOREIGN KEY (martialArtID) REFERENCES MartialArts(martialArtID) ON DELETE CASCADE,
        FOREIGN KEY (moveID) REFERENCES Moves(moveID) ON DELETE CASCADE
    );

    CREATE TABLE Events (
        eventID int AUTO_INCREMENT,
        name varchar(100) NOT NULL,
        date datetime NOT NULL,
        martialArtID int,
        PRIMARY KEY (eventID),
        FOREIGN KEY (martialArtID) REFERENCES MartialArts(martialArtID) ON DELETE SET NULL
    );

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

    INSERT INTO MartialArts (name)
    VALUES
        ('Muay Thai'),
        ('Jiu Jitsu'),
        ('MMA');

    INSERT INTO Moves (name, description)
    VALUES
        ('Jab', 'A straight punch with your lead hand'),
        ('Parallel Elbow Strike', 'Swing your elbow at your opponent, keeping your strike parallel to the ground. Aim to hit your opponent''s head in their jaw, temple, or chin. This does not need a lot of force behind it to be effective.'),
        ('Shrimping', 'A hip escape. Practice by starting on laying on your back, knees bent and feet planted on the ground. Bridge your hips up and roll onto one of your shoulders. Use your foot (same side as the shoulder you are laying on) to push your body and slide your hips back while you pivot on your shoulder. Your body should curve (like a shrimp). Reset your body and repeat the movement on the other side. You should be able to move all the way down the mat like this. This is a good way to escape an opponent standing over you without giving them more openings. ');

    INSERT INTO MartialArtMoves (martialArtID, moveID)
    VALUES
        ((SELECT martialArtID FROM MartialArts WHERE name = 'Muay Thai'), (SELECT moveID FROM Moves WHERE name = 'Jab')),
        ((SELECT martialArtID FROM MartialArts WHERE name = 'MMA'), (SELECT moveID FROM Moves WHERE name = 'Jab')),
        ((SELECT martialArtID FROM MartialArts WHERE name = 'Muay Thai'), (SELECT moveID FROM Moves WHERE name = 'Parallel Elbow Strike')),
        ((SELECT martialArtID FROM MartialArts WHERE name = 'MMA'), (SELECT moveID FROM Moves WHERE name = 'Parallel Elbow Strike')),
        ((SELECT martialArtID FROM MartialArts WHERE name = 'Jiu Jitsu'), (SELECT moveID FROM Moves WHERE name = 'Shrimping'));

    INSERT INTO Events (name, date, martialArtID)
    VALUES
        ('BJJ Open', '2026-11-15 00:00:00', (SELECT martialArtID FROM MartialArts WHERE name = 'Jiu Jitsu')),
        ('Gym Open Mat', '2026-12-07 00:00:00', NULL),
        ('UFC Fight Night', '2026-12-19 00:00:00', (SELECT martialArtID FROM MartialArts WHERE name = 'MMA'));

    INSERT INTO StudySessions (date, duration, martialArtID, eventID)
    VALUES
        ('2026-10-03 00:00:00', '01:01:00', (SELECT martialArtID FROM MartialArts WHERE name = 'Muay Thai'), NULL),
        ('2026-10-05 00:00:00', '00:37:00', (SELECT martialArtID FROM MartialArts WHERE name = 'Jiu Jitsu'), (SELECT eventID FROM Events WHERE name = 'BJJ Open')),
        ('2026-10-07 00:00:00', '00:53:00', (SELECT martialArtID FROM MartialArts WHERE name = 'MMA'), (SELECT eventID FROM Events WHERE name = 'UFC Fight Night'));

    SET FOREIGN_KEY_CHECKS = 1;
END //
DELIMITER ;
