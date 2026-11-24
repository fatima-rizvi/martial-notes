> Team 20: Fatima Rizvi and Michael Yanez
> Note: All work below is our own. This prompt, which was made to be used by GitHub copilot, was written entirely on our own. The prompt references code examples and the code examples are from the following Oregon State University CS340 explorations: Implementing CUD operations using PL/SQL. The prompt instructions were partially based off of the Project Step 4 Draft assignment instructions. The agent's work was checked and verified after each phase, and some additional instructions/guidance were needed. After going through all the phases, the agent updated the README on it's own.

You are a senior software engineer that writes clean and concise code. Your job is to make a series of upgrades to this SQL database driven Python application. These upgrades will be made in phases, we will go one at a time. For each phase, start by reading the instructions I give you. Next, come up with a plan to implement those changes, and pause if you have any questions or need clarification from me. Wait until I approve the plan to start implementing it.

## Phase 1: Convert the create, update, and delete operations from the DML file. 

1. Start by creating a file called `martial_notes_plsql.sql` in the `SQL` folder. This is where all of the stored procedures for the reset, create, update, and delete operations are going to go. 
2. Create a list of all of the create, update, and delete operations in the `martial_notes_dml.sql` file. The read operations will not be converted. 
3. First, create a stored procedure for each create operation. Follow the naming convention `sp_Create<entity>`.
4. Next, create a stored procedure for each update operation. Follow the naming convention `sp_Update<entity>`.
5. Third, create a stored procedure for each delete operation. Follow the naming convention `sp_Update<entity>`.
6. After you create the procedures, please review the, and check them against the original DML sql. 

SQL examples from class notes:
```sql
DROP PROCEDURE IF EXISTS sp_CreatePerson;

DELIMITER //
CREATE PROCEDURE sp_CreatePerson(
    IN p_fname VARCHAR(255),
    IN p_lname VARCHAR(255),
    IN p_homeworld INT,
    IN p_age INT,
    OUT p_id INT
)
BEGIN
    INSERT INTO bsg_people (fname, lname, homeworld, age)
    VALUES (p_fname, p_lname, p_homeworld, p_age);

    SELECT LAST_INSERT_ID() INTO p_id;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_UpdatePerson;

DELIMITER //
CREATE PROCEDURE sp_UpdatePerson(
    IN p_id INT,
    IN p_fname VARCHAR(255),
    IN p_lname VARCHAR(255),
    IN p_homeworld INT,
    IN p_age INT
)
BEGIN
    UPDATE bsg_people
    SET fname = p_fname,
        lname = p_lname,
        homeworld = p_homeworld,
        age = p_age
    WHERE id = p_id;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_DeletePerson;

DELIMITER //
CREATE PROCEDURE sp_DeletePerson(IN p_id INT)
BEGIN
    DECLARE v_rows_deleted INT DEFAULT 0;
    DECLARE error_message VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

        DELETE FROM bsg_cert_people
        WHERE pid = p_id;

        DELETE FROM bsg_people
        WHERE id = p_id;

        SET v_rows_deleted = ROW_COUNT();

        IF v_rows_deleted = 0 THEN
            SET error_message = CONCAT('No matching record found in bsg_people for id: ', p_id);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;
END //
DELIMITER ;
```

## Phase 2: Create the RESET stored proc
1. The procedure you need to make is called `sp_ResetMartialNotesDatabase`. This procedure needs to completely reset the user's database back to it's initial state from the DDL file. This procedure can also be used to initialize the database. Examine the sample reset procedure below (it was intended for a different database). This procedure will go into the file `martial_notes_plsql.sql` that you made.

SQL example from class notes:
```sql
DROP PROCEDURE IF EXISTS sp_ResetBSGDatabase;

DELIMITER //
CREATE PROCEDURE sp_ResetBSGDatabase()
BEGIN
        SET FOREIGN_KEY_CHECKS = 0;

        DROP TABLE IF EXISTS bsg_cert_people;
        DROP TABLE IF EXISTS bsg_people;
        DROP TABLE IF EXISTS bsg_cert;
        DROP TABLE IF EXISTS bsg_planets;

        CREATE TABLE bsg_planets (
            id INT NOT NULL AUTO_INCREMENT,
            name VARCHAR(255) NOT NULL,
            population BIGINT DEFAULT NULL,
            language VARCHAR(255) DEFAULT NULL,
            capital VARCHAR(255) DEFAULT NULL,
            PRIMARY KEY (id),
            UNIQUE KEY name (name)
        ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

        CREATE TABLE bsg_cert (
            id INT NOT NULL AUTO_INCREMENT,
            title VARCHAR(255) NOT NULL,
            PRIMARY KEY (id)
        ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

        CREATE TABLE bsg_people (
            id INT NOT NULL AUTO_INCREMENT,
            fname VARCHAR(255) NOT NULL,
            lname VARCHAR(255) DEFAULT NULL,
            homeworld INT DEFAULT NULL,
            age INT DEFAULT NULL,
            PRIMARY KEY (id),
            KEY homeworld (homeworld),
            CONSTRAINT bsg_people_ibfk_1 FOREIGN KEY (homeworld)
                REFERENCES bsg_planets (id)
                ON DELETE SET NULL ON UPDATE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

        CREATE TABLE bsg_cert_people (
            cid INT NOT NULL,
            pid INT NOT NULL,
            PRIMARY KEY (cid, pid),
            KEY pid (pid),
            CONSTRAINT bsg_cert_people_ibfk_1 FOREIGN KEY (cid) REFERENCES bsg_cert (id),
            CONSTRAINT bsg_cert_people_ibfk_2 FOREIGN KEY (pid) REFERENCES bsg_people (id)
        ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

        INSERT INTO bsg_planets (id, name, population, language, capital) VALUES
            (1, 'Gemenon', 2800000000, 'Old Gemenese', 'Oranu'),
            (2, 'Leonis', 2600000000, 'Leonese', 'Luminere'),
            (3, 'Caprica', 4900000000, 'Caprican', 'Caprica City'),
            (7, 'Sagittaron', 1700000000, NULL, 'Tawa'),
            (16, 'Aquaria', 25000, NULL, NULL),
            (17, 'Canceron', 6700000000, NULL, 'Hades'),
            (18, 'Libran', 2100000, NULL, NULL),
            (19, 'Picon', 1400000000, NULL, 'Queestown'),
            (20, 'Scorpia', 450000000, NULL, 'Celeste'),
            (21, 'Tauron', 2500000000, 'Tauron', 'Hypatia'),
            (22, 'Virgon', 4300000000, NULL, 'Boskirk');

        INSERT INTO bsg_cert (id, title) VALUES
            (1, 'Raptor'),
            (2, 'Viper'),
            (3, 'Mechanic'),
            (4, 'Command');

        INSERT INTO bsg_people (id, fname, lname, homeworld, age) VALUES
            (1, 'William', 'Adama', 3, 61),
            (2, 'Lee', 'Adama', 3, 30),
            (3, 'Laura', 'Roslin', 3, NULL),
            (4, 'Kara', 'Thrace', 3, NULL),
            (5, 'Gaius', 'Baltar', 3, NULL),
            (6, 'Saul', 'Tigh', NULL, 71),
            (7, 'Karl', 'Agathon', 1, NULL),
            (8, 'Galen', 'Tyrol', 1, 32),
            (9, 'Callandra', 'Henderson', NULL, NULL);

        INSERT INTO bsg_cert_people (cid, pid) VALUES
            (2, 2),
            (4, 2),
            (4, 3),
            (2, 4),
            (4, 6),
            (1, 7),
            (3, 8),
            (3, 9);

        SET FOREIGN_KEY_CHECKS = 1;
END //
DELIMITER ;
```

3. After you initially create the procedure, please review it and check it against the original DDL. 

## Phase 3: Update the DDL file
1. Go to `martial_notes_ddl.sql`. Refactor it to use the new stored procedures as appropriate (not including the reset stored proc).
2. 3. After you refactor it, please review it and check it against the original DDL. 

## Phase 4: Update the main app to use PL/SQL
1. Create a new file call `martial_notes_app_plsql.py` by copying `martial_notes_app.py`
2. Examine the methods in the `MartialNotesQueries` class. All of the embedded SQL for the create, update, and delete operations needs to be updated to call the stored procedures that you just created in phase 2. Read methods will not change. These updates will be made in `martial_notes_app_plsql.py`.
3. Refactor the create methods first. 

SQL examples from class notes:
```sql
def add_person(self, fname, lname, homeworld_id, age):
    cursor = self.db.cursor()
    sql = "CALL sp_CreatePerson(%s, %s, %s, %s, @new_id)"
    cursor.execute(sql, (fname, lname, homeworld_id, age))
    # The procedure may leave one or more pending result sets on the cursor.
    # Drain them before issuing the next statement or the connector will raise an error.
    while cursor.nextset():
        pass

     # The OUT parameter @new_id was set inside the procedure.
     # We must retrieve it via a separate SELECT because OUT params are not
     # returned as a result set; they are stored as session-level
    cursor.execute("SELECT @new_id")
    new_id = cursor.fetchone()[0]

    self.db.commit()
    cursor.close()
    return 1 if new_id else 0
```

4. Next refactor the update methods. 

SQL examples from class notes:
```sql
def update_person(self, person_id, fname, lname, homeworld_id, age):
    cursor = self.db.cursor()
    sql = "CALL sp_UpdatePerson(%s, %s, %s, %s, %s)"
    cursor.execute(sql, (person_id, fname, lname, homeworld_id, age))
    # rowcount reflects the number of rows affected by the UPDATE inside the procedure.
    rowcount = cursor.rowcount

    self.db.commit()
    cursor.close()
    return rowcount
```

4. Then refactor the delete methods. 

SQL examples from class notes:
```sql
def delete_person(self, person_id):
    cursor = self.db.cursor()
    sql = "CALL sp_DeletePerson(%s)"
    cursor.execute(sql, (person_id,))
    # rowcount reflects the rows deleted by the final DELETE inside the procedure.
    # The procedure raises a SQLSTATE error if no matching id exists.
    rowcount = cursor.rowcount

    self.db.commit()
    cursor.close()
    return rowcount
```

5. Last, add a new method called reset_database that calls the new stored proc `sp_ResetMartialNotesDatabase`.

## Phase 5: Update the test runner
1. Update the test runner to import the class from the new python plsql app instead of the previous python app.
2. Pause here so that I can test the new test runner and compare it's output to our existing CLI output. Wait for my prompt to continue.
2. Add a call to the test runner that calls the reset stored proc. 
3. Add a call below that tries to select/read a previously deleted value to prove that the database has been reset. 