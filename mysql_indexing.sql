CREATE DATABASE CollegeDB;
USE CollegeDB;
CREATE TABLE Student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    branch VARCHAR(50),
    age INT,
    city VARCHAR(50),
    cgpa DECIMAL(3,2)
);
INSERT INTO Student(name,email,branch,age,city,cgpa)
VALUES
('Aditi','aditi@gmail.com','CSE',21,'Nagpur',8.90),
('Rahul','rahul@gmail.com','IT',22,'Pune',8.50),
('Sneha','sneha@gmail.com','CSE',20,'Mumbai',9.20),
('Aman','aman@gmail.com','ECE',23,'Delhi',7.80),
('Priya','priya@gmail.com','CSE',21,'Nagpur',9.10),
('Rohit','rohit@gmail.com','IT',22,'Pune',8.40),
('Neha','neha@gmail.com','CSE',20,'Nagpur',8.80),
('Karan','karan@gmail.com','ME',23,'Indore',7.50);
SELECT * FROM Student;
EXPLAIN
SELECT *
FROM Student
WHERE city='Nagpur';

CREATE INDEX idx_city
ON Student(city);

CREATE INDEX idx_branch
ON Student(branch);

CREATE INDEX idx_email
ON Student(email);

SHOW INDEX FROM Student;
EXPLAIN
SELECT *
FROM Student
WHERE city='Nagpur';

SELECT name,branch,cgpa
FROM Student;

SELECT name,cgpa
FROM Student
WHERE branch='CSE';

SELECT *
FROM Student
ORDER BY city;
CREATE INDEX idx_sort
ON Student(city);

SELECT branch,
COUNT(*) AS TotalStudents
FROM Student
GROUP BY branch;

SELECT branch,
AVG(cgpa)
FROM Student
GROUP BY branch;

SELECT *
FROM Student
ORDER BY cgpa DESC
LIMIT 1;

SELECT *
FROM Student
WHERE city='Nagpur';

SELECT *
FROM Student
WHERE branch='CSE';

DROP INDEX idx_city
ON Student;

OPTIMIZE TABLE Student;

ANALYZE TABLE Student;

SHOW TABLE STATUS;

SHOW TABLES;

DESC Student;

SHOW DATABASES;

DELETE FROM Student
WHERE student_id=8;

UPDATE Student
SET cgpa=9.50
WHERE name='Aditi';

SELECT *
FROM Student
WHERE email='aditi@gmail.com';

SELECT COUNT(*)
FROM Student;

SELECT AVG(cgpa)
FROM Student;

SELECT MAX(cgpa)
FROM Student;

SELECT MIN(cgpa)
FROM Student;

EXPLAIN
SELECT *
FROM Student
WHERE email='aditi@gmail.com';

XPLAIN
SELECT *
FROM Student
WHERE email='aditi@gmail.com';

SELECT
AVG(cgpa) AS AverageCGPA
FROM Student;


SELECT
MAX(cgpa)
FROM Student;

SELECT
MIN(cgpa)
FROM Student;
SELECT *
FROM Student
ORDER BY cgpa DESC
LIMIT 3;
SELECT *
FROM Student
WHERE name LIKE 'A%';
ANALYZE TABLE Student;
OPTIMIZE TABLE Student;
UPDATE Student
SET cgpa=9.40
WHERE name='Aditi';

CREATE INDEX idx_branch_city
ON Student(branch,city);

EXPLAIN
SELECT *
FROM Student
WHERE branch='CSE'
AND city='Nagpur';

SHOW INDEX
FROM Student;

ANALYZE TABLE Student;

OPTIMIZE TABLE Student;






/*=========================================================
 PROJECT : MySQL Database Indexing and Optimization
 AUTHOR  : Aditi Shirbhate
 PURPOSE : Demonstrate MySQL Optimization Techniques
=========================================================*/

---------------------------------------------------------
-- STEP 1 : Create Database
---------------------------------------------------------

CREATE DATABASE CollegeDB;

USE CollegeDB;

---------------------------------------------------------
-- STEP 2 : Create Student Table
---------------------------------------------------------

CREATE TABLE Student
(
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    branch VARCHAR(50),
    city VARCHAR(50),
    age INT,
    cgpa DECIMAL(3,2)
);

---------------------------------------------------------
-- STEP 3 : Insert Records
---------------------------------------------------------

INSERT INTO Student(name,email,branch,city,age,cgpa)
VALUES
('Aditi','aditi@gmail.com','CSE','Nagpur',21,8.90),
('Rahul','rahul@gmail.com','IT','Pune',22,8.30),
('Sneha','sneha@gmail.com','CSE','Mumbai',20,9.10),
('Rohan','rohan@gmail.com','ECE','Delhi',23,8.00),
('Neha','neha@gmail.com','IT','Nagpur',21,8.70),
('Priya','priya@gmail.com','CSE','Nagpur',20,9.40);

---------------------------------------------------------
-- STEP 4 : Display Records
---------------------------------------------------------

SELECT * FROM Student;

---------------------------------------------------------
-- STEP 5 : Query Execution Plan Before Index
---------------------------------------------------------

EXPLAIN
SELECT *
FROM Student
WHERE city='Nagpur';

---------------------------------------------------------
-- STEP 6 : Create Index
---------------------------------------------------------

CREATE INDEX idx_city
ON Student(city);

CREATE INDEX idx_branch
ON Student(branch);

CREATE INDEX idx_email
ON Student(email);

---------------------------------------------------------
-- STEP 7 : Composite Index
---------------------------------------------------------

CREATE INDEX idx_branch_city
ON Student(branch,city);

---------------------------------------------------------
-- STEP 8 : Show Indexes
---------------------------------------------------------

SHOW INDEX
FROM Student;

---------------------------------------------------------
-- STEP 9 : Query Execution After Index
---------------------------------------------------------

EXPLAIN
SELECT *
FROM Student
WHERE city='Nagpur';

---------------------------------------------------------
-- STEP 10 : Optimized Query
---------------------------------------------------------

SELECT
name,
branch,
cgpa
FROM Student
WHERE city='Nagpur';

---------------------------------------------------------
-- STEP 11 : ORDER BY
---------------------------------------------------------

EXPLAIN
SELECT *
FROM Student
ORDER BY city;

---------------------------------------------------------
-- STEP 12 : GROUP BY
---------------------------------------------------------

SELECT
branch,
COUNT(*) TotalStudents
FROM Student
GROUP BY branch;

---------------------------------------------------------
-- STEP 13 : HAVING
---------------------------------------------------------

SELECT
branch,
AVG(cgpa) AverageCGPA
FROM Student
GROUP BY branch
HAVING AVG(cgpa)>8.5;

---------------------------------------------------------
-- STEP 14 : LIMIT
---------------------------------------------------------

SELECT *
FROM Student
ORDER BY cgpa DESC
LIMIT 3;

---------------------------------------------------------
-- STEP 15 : ANALYZE TABLE
---------------------------------------------------------

ANALYZE TABLE Student;

---------------------------------------------------------
-- STEP 16 : OPTIMIZE TABLE
---------------------------------------------------------

OPTIMIZE TABLE Student;

---------------------------------------------------------
-- STEP 17 : Update
---------------------------------------------------------

UPDATE Student
SET cgpa=9.50
WHERE name='Aditi';

---------------------------------------------------------
-- STEP 18 : Delete
---------------------------------------------------------

DELETE FROM Student
WHERE student_id=6;

---------------------------------------------------------
-- STEP 19 : Final Performance Check
---------------------------------------------------------

EXPLAIN
SELECT *
FROM Student
WHERE email='aditi@gmail.com';

SHOW INDEX FROM Student;











