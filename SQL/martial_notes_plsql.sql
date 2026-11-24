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

