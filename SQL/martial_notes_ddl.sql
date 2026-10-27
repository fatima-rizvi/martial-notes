-- Team 20: Fatima Rizvi and Michael Yanez
-- All work below is our own, aside from the recommended disabling and re-enabling of commits and foreign key checks which were suggested in the CS340 Project Step 2 Draft assignment instructions. 
-- Disabling commits and foreign key checks to minimize import errors
SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

-- Creating our 5 tables (4 entities and 1 intersection table)
DROP TABLE IF EXISTS MartialArts;

CREATE TABLE MartialArts (
    martialArtID int NOT NULL AUTO_INCREMENT,
    name varchar(50),
    PRIMARY KEY (martialArtID)
);

DROP TABLE IF EXISTS Moves;

CREATE TABLE Moves (
    moveID int NOT NULL AUTO_INCREMENT,
    name varchar(100),
    description text,
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
    date date NOT NULL,
    duration time NOT NULL,
    martialArtID int NOT NULL, 
    eventID int, 
    PRIMARY KEY (studySessionID),
    FOREIGN KEY (martialArtID) REFERENCES MartialArts(martialArtID) ON DELETE CASCADE,
    FOREIGN KEY (eventID) REFERENCES Events(eventID) ON DELETE SET NULL
);

-- Inserting the sample data
INSERT INTO MartialArts (
    name
)
VALUES 
(
    'Muay Thai'
),
(
    'Jiu Jitsu'
),
(
    'MMA'
);

INSERT INTO Moves (
    name,
    description
)
VALUES 
(
    'Jab',
    'A straight punch with your lead hand'
),
(
    'Parallel Elbow Strike',
    "Swing your elbow at your opponent, keeping your strike parallel to the ground. Aim to hit your opponent's head in theri jaw, temple, or chin. This does not need a lot of force behind it to be effective."

),
(
    'Shrimping',
    'A hip escape. Practice by starting on laying on your back, knees bent and feet planted on the ground. Bridge your hips up and roll onto one of your shoulders. Use your foot (same side as the shoulder you are laying on) to push your body and slide your hips back while you pivot on your shoulder. Your body should curve (like a shrimp). Reset your body and repeat the movement on the other side. You should be able to move all the way down the mat like this. This is a good way to escape an opponent standing over you without giving them more openings. '
);

INSERT INTO MartialArtMoves (
    martialArtID,
    moveID
)
VALUES
(
    (select martialArtID from MartialArts where name = 'Muay Thai'),
    (select moveID from Moves where name = 'Jab')
),
(
    (select martialArtID from MartialArts where name = 'MMA'),
    (select moveID from Moves where name = 'Jab')
),
(
    (select martialArtID from MartialArts where name = 'Muay Thai'),
    (select moveID from Moves where name = 'Parallel Elbow Strike')
),
(
    (select martialArtID from MartialArts where name = 'MMA'),
    (select moveID from Moves where name = 'Parallel Elbow Strike')
),
(
    (select martialArtID from MartialArts where name = 'Jiu Jitsu'),
    (select moveID from Moves where name = 'Shrimping')
);

INSERT INTO Events (
    name,
    date,
    martialArtID
)
VALUES 
(
    'BJJ Open',
    '2026-11-15 00:00:00',
    (select martialArtID from MartialArts where name = 'Jiu Jitsu')
),
(
    'Gym Open Mat',
    '2026-12-07 00:00:00',
    null
),
(
    'UFC Fight Night',
    '2026-12-19 00:00:00',
    (select martialArtID from MartialArts where name = 'MMA')
);

INSERT INTO StudySessions (
    date,
    duration,
    martialArtID,
    eventID
)
VALUES 
(
    '2026-10-03',
    '01:01:00',
    (select martialArtID from MartialArts where name = 'Muay Thai'),
    null
),
(
    '2026-10-05',
    '00:37:00',
    (select martialArtID from MartialArts where name = 'Jiu Jitsu'),
    (select eventID from Events where name = 'BJJ Open')
),
(
    '2026-10-07',
    '00:53:00',
    (select martialArtID from MartialArts where name = 'MMA'),
    (select eventID from Events where name = 'UFC Fight Night')
);


-- Disabling commits and foreign ley checks to minimize import errors
SET FOREIGN_KEY_CHECKS=1;
COMMIT;