/*==============================================================================
 PROJECT : MySQL Database Indexing and Optimization
 AUTHOR  : Aditi Shirbhate
 PURPOSE : Demonstrate MySQL Optimization Techniques & Execution Plan Analysis
==============================================================================*/

--------------------------------------------------------------------------------
-- STEP 1 : Create and Initialize Database
--------------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS CollegeDB;
USE CollegeDB;

--------------------------------------------------------------------------------
-- STEP 2 : Create Student Table with Appropriate Constraints
--------------------------------------------------------------------------------
DROP TABLE IF EXISTS Student;
CREATE TABLE Student (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE, -- Added UNIQUE constraint for best practices
    branch VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    age INT CHECK (age >= 18),         -- Added data integrity check constraint
    cgpa DECIMAL(3,2) NOT NULL
);

--------------------------------------------------------------------------------
-- STEP 3 : Insert Representative Data Records
--------------------------------------------------------------------------------
INSERT INTO Student (name, email, branch, city, age, cgpa)
VALUES
('Aditi', 'aditi@gmail.com', 'CSE', 'Nagpur', 21, 8.90),
('Rahul', 'rahul@gmail.com', 'IT', 'Pune', 22, 8.30),
('Sneha', 'sneha@gmail.com', 'CSE', 'Mumbai', 20, 9.10),
('Rohan', 'rohan@gmail.com', 'ECE', 'Delhi', 23, 8.00),
('Neha', 'neha@gmail.com', 'IT', 'Nagpur', 21, 8.70),
('Priya', 'priya@gmail.com', 'CSE', 'Nagpur', 20, 9.40);

--------------------------------------------------------------------------------
-- STEP 4 : Query Execution Plan BEFORE Indexing
-- ANALYSIS: This query triggers a Full Table Scan (type: ALL) because MySQL 
-- must search every row in the dataset sequentially to match the 'city' column.
--------------------------------------------------------------------------------
EXPLAIN 
SELECT student_id, name, branch, cgpa 
FROM Student 
WHERE city = 'Nagpur';

--------------------------------------------------------------------------------
-- STEP 5 : Create Strategic Single-Column & Composite Indexes
--------------------------------------------------------------------------------
-- Single column indexes for high-frequency search filtering
CREATE INDEX idx_city ON Student(city);
CREATE INDEX idx_branch ON Student(branch);

-- Composite index optimized for multi-conditional filtering on branch & city
CREATE INDEX idx_branch_city ON Student(branch, city);

--------------------------------------------------------------------------------
-- STEP 6 : Verify Newly Created Database Indexes
--------------------------------------------------------------------------------
SHOW INDEX FROM Student;

--------------------------------------------------------------------------------
-- STEP 7 : Query Execution Plan AFTER Indexing
-- ANALYSIS: The optimizer now utilizes the 'idx_city' index (type: ref). 
-- The 'rows' metric drops, drastically reducing the search space and execution cost.
--------------------------------------------------------------------------------
EXPLAIN 
SELECT student_id, name, branch, cgpa 
FROM Student 
WHERE city = 'Nagpur';

--------------------------------------------------------------------------------
-- STEP 8 : Performance Optimization (Avoiding SELECT * / Covering Indexes)
-- ANALYSIS: By selecting only specific required columns rather than using '*', 
-- we minimize network overhead and memory consumption.
--------------------------------------------------------------------------------
SELECT name, branch, cgpa 
FROM Student 
WHERE city = 'Nagpur';

--------------------------------------------------------------------------------
-- STEP 9 : Analyzing Sorting (ORDER BY) Optimization
-- ANALYSIS: Sorting by 'city' can now utilize the 'idx_city' B-Tree structure,
-- eliminating the expensive 'Using filesort' penalty during execution.
--------------------------------------------------------------------------------
EXPLAIN 
SELECT student_id, name, city 
FROM Student 
ORDER BY city;

--------------------------------------------------------------------------------
-- STEP 10 : Grouping and Filtering (GROUP BY & HAVING)
--------------------------------------------------------------------------------
SELECT branch, COUNT(*) AS TotalStudents, AVG(cgpa) AS AverageCGPA
FROM Student
GROUP BY branch
HAVING AVG(cgpa) > 8.5;

--------------------------------------------------------------------------------
-- STEP 11 : Top Performing Students (LIMIT Optimization)
--------------------------------------------------------------------------------
SELECT student_id, name, cgpa 
FROM Student 
ORDER BY cgpa DESC 
LIMIT 3;

--------------------------------------------------------------------------------
-- STEP 12 : Table Data Maintenance and Statistics Refreshes
--------------------------------------------------------------------------------
-- Re-analyzes key distribution and updates statistics for the query optimizer
ANALYZE TABLE Student;

-- Defragments data storage and reclaims unused cluster file space
OPTIMIZE TABLE Student;

--------------------------------------------------------------------------------
-- STEP 13 : Data Manipulation (Updates & Deletes via Indexed Keys)
-- ANALYSIS: Modifications target indexed values or the Primary Key 
-- to ensure execution remains efficient and scoped.
--------------------------------------------------------------------------------
UPDATE Student 
SET cgpa = 9.50 
WHERE student_id = 1; -- Targeted by Primary Key rather than non-unique Name string

DELETE FROM Student 
WHERE student_id = 6;

--------------------------------------------------------------------------------
-- STEP 14 : Final Performance Verification via Covering Query
-- ANALYSIS: Utilizing the implicitly generated Primary Key index on 'email' 
-- (due to the UNIQUE constraint) results in a highly efficient point-lookup scan.
--------------------------------------------------------------------------------
EXPLAIN 
SELECT student_id, name, email 
FROM Student 
WHERE email = 'aditi@gmail.com';