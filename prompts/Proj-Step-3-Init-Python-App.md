> Team 20: Fatima Rizvi and Michael Yanez
> Note: All work below is our own. This prompt, which was made to be used by GitHub copilot, was written entirely on our own. The prompt references code examples and the code examples are from the Oregon State University CS340 Python Crud Query App Assignment. The prompt instructions were partially based off of the Project Step 3 Draft Version assignment instructions.

You are a software engineer that specializes in writing clean, concise Python code. Your job is to create a Python application that is connected to a databse. The python app will manage database connections that has methods that will hold and excute SQL querires. The DDL and DML SQL files and queries already exist, these are the queries the python application should be using (with adjustments made to correctly pass in arguments to the parameters). 

- The application you make needs to define a class that implements the application-tier interface for our data base. 
- The class has to implement all of the queries in the DML file (martial_notes_dml.sql).
- Each method should use parameterized queries.
- Each read method should return the results that the SQL returns, and each create, and update, and delete method should return either the row count.
- Look at both the DDL and DML sql files to correctly build the methods, and make sure the SQL queries encapsulated in the app are taken directly from martial_notes_dml.sql.
- Make sure that you check if a parameter is allowed to be nullable by looking at the entity in the DDL sql file. If it's allowed to be nullable, then ensure that's reflected in the method parameters and arguments. 
- The placeholders in the DML queries should be translate to use the same format as the code examples below. The parameter names for each method should be simple (ex: martialArtID, name, description)
- This class will go in it's own python module in the file called martial_notes_app.py. 
Look at the sample code example below

Example from previous class assignment:
```python
import mysql.connector

class CertPersonQueries(object):
    """Python app that queries people/cert relationships in bsg_db."""

    def __init__(self, cursor, connection=None):
        self.cursor = cursor
        self.connection = connection

    def _commit(self):
        """Commit if a connection object was provided."""
        if self.connection is not None:
            self.connection.commit()

    def get_all_people_cert(self, mode="byc"):
        """
        Join people fname, lname with certs through bsg_cert_people.
        If mode is by person (byp): output columns are (*fname, lname, cert).
        If mode is by cert (byc): output columns are (cert*, fname, lname).
        Default is byc. *Orderby.
        """

        if mode == "byp":
            sql = """
            SELECT fname, lname, bsg_cert.title AS cert
            FROM bsg_people
            inner JOIN bsg_cert_people ON bsg_cert_people.pid = bsg_people.id
            left JOIN bsg_cert on bsg_cert_people.cid = bsg_cert.id
            order by bsg_people.fname
            """
        elif mode == "byc":
            sql = """
            SELECT bsg_cert.title AS cert, fname, lname
            FROM bsg_cert
            inner JOIN bsg_cert_people ON bsg_cert_people.cid = bsg_cert.id
            left JOIN bsg_people on bsg_cert_people.pid = bsg_people.id
            order by cert
            """

        self.cursor.execute(sql)
        results = self.cursor.fetchall()
        return results

    def cnt_cert_person(self, mode="byc"):
        """
        Count certifications grouped by person (byp) -output *fname, lname, count
        Or count people grouped by certificate (byc) -output *cert, count
        Default is byc. *Orderby.
        """

        if mode == "byp":
            sql = """
            SELECT fname, lname, COUNT(bsg_cert_people.pid) as count
            FROM bsg_people
            left JOIN bsg_cert_people ON bsg_people.id = bsg_cert_people.pid
            left JOIN bsg_cert on bsg_cert_people.cid = bsg_cert.id
            GROUP BY bsg_people.id
            ORDER BY fname
            """
        elif mode == "byc":
            sql = """
            SELECT bsg_cert.title as cert, COUNT(bsg_cert_people.cid) as count
            FROM bsg_cert
            inner JOIN bsg_cert_people ON bsg_cert_people.cid = bsg_cert.id
            left JOIN bsg_people on bsg_cert_people.pid = bsg_people.id
            GROUP BY bsg_cert.id
            ORDER BY bsg_cert.title
            """

        self.cursor.execute(sql)
        results = self.cursor.fetchall()
        return results

    def add_cert_person(self, c=None, p=None):
        """Insert cert-person pair into bsg_cert_people."""

        sql = """
        INSERT INTO bsg_cert_people (cid, pid)
        VALUES (%s, %s)
        """
        self.cursor.execute(sql, (c, p))
        return self.cursor.rowcount

    def update_cert(self, c=None, p=None):
        """
        Update the cert assignment for a given person.
        """
        sql = """
        UPDATE bsg_cert_people
        SET cid=%s
        WHERE pid=%s
        """
        self.cursor.execute(sql, (c, p))
        rowcount = self.cursor.rowcount
        return rowcount

    def delete_cert(self, c=None, p=None):
        """Delete one cert-person relationship."""
        sql = """
        DELETE FROM bsg_cert_people
        WHERE cid=%s AND pid=%s
        """
        self.cursor.execute(sql, (c, p))
        rowcount = self.cursor.rowcount
        return rowcount
```

The python module you make to implement below will need to be testable. That will be done through another Python module in a seperate file. You will build that python module as well. The test python module will be called run_martial_notes_app.py. 

- This module should have a minimal script. 
- It needs to import the application tier class, and call every method in the application using every variation of the method (meaning it needs to hit all branches of conditional statements. It also needs to test every method that has nullable parameters with both null and non-null arguments passed in to the nullable parameter)
- It needs to show that all the required CRUD operations were successfully executed. It can do this by just printing results for now. 
- If possible, I would like the test module to create a temporary test database, execute the DDL script, and then run all of it's tests. Once the tests are over, it should drop the test DB. Add comments around the test db creation/DDL script running and the db dropping to note that these can be commented out if desired


Look at the sample code example below

Example from previous class assignment:
```python
import mysql.connector
from python_crud import CertPersonQueries

# replace with your actual DB credentials
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='R00tP@ssw0rd',
    database='cs340_rizvifa'
)
cursor = conn.cursor()

q = CertPersonQueries(cursor, conn)

print(q.get_all_people_cert())
print(q.cnt_cert_person('byp'))

print(q.add_cert_person(2, 7))
conn.commit()

print(q.update_cert(4, 7))
conn.commit()

print(q.delete_cert(4, 7))
conn.commit()

cursor.close()
conn.close()
```

Pause if you have any questions for me or need any clarification. The code for both of these python modules should be simple and easy to read. Each class and method should have a clean and concise desciptive comment. 