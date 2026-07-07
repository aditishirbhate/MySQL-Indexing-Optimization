/*==============================================================================
 PROJECT : MySQL Database Indexing and Optimization
 AUTHOR  : Aditi Shirbhate
 PURPOSE : Demonstrate and Document MySQL Performance Optimization Techniques
==============================================================================*/

--------------------------------------------------------------------------------
-- STEP 1 : Database Setup & Initialization
--------------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS CollegeDB;
USE CollegeDB;

--------------------------------------------------------------------------------
-- STEP 2 : Schema Creation with Proper Constraints
--------------------------------------------------------------------------------
DROP TABLE IF EXISTS Student;

CREATE TABLE Student (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE, -- Unique constraint automatically builds an internal index
    branch VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    cgpa DECIMAL(3,2) NOT NULL
);

--------------------------------------------------------------------------------
-- STEP 3 : Data Population
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
-- STEP 4 : Query Performance Analysis BEFORE Indexing
-- ANALYSIS: Running EXPLAIN here reveals a type of 'ALL' (Full Table Scan).
-- Because no index exists on 'city', MySQL must check every row sequentially.
--------------------------------------------------------------------------------
EXPLAIN 
SELECT name, branch, cgpa 
FROM Student 
WHERE city = 'Nagpur';

--------------------------------------------------------------------------------
-- STEP 5 : Applying Strategic Indexing Techniques
--------------------------------------------------------------------------------
-- Single-column index for frequent point-lookups by geography
CREATE INDEX idx_city ON Student(city);

-- Composite index optimized specifically for multi-conditional filter queries
CREATE INDEX idx_branch_city ON Student(branch, city);

--------------------------------------------------------------------------------
-- STEP 6 : Index Verification
--------------------------------------------------------------------------------
SHOW INDEX FROM Student;

--------------------------------------------------------------------------------
-- STEP 7 : Query Performance Analysis AFTER Indexing
-- ANALYSIS: Running EXPLAIN now shows a type of 'ref' utilizing 'idx_city'.
-- The scanned row-count drops dramatically, preventing costly table scans.
--------------------------------------------------------------------------------
EXPLAIN 
SELECT name, branch, cgpa 
FROM Student 
WHERE city = 'Nagpur';

--------------------------------------------------------------------------------
-- STEP 8 : Advanced Queries (Aggregations & Sorting Optimization)
-- ANALYSIS: Using column lists instead of SELECT * minimizes memory footprint.
--------------------------------------------------------------------------------
-- Grouping & Aggregating data with post-filtration
SELECT branch, COUNT(*) AS TotalStudents, AVG(cgpa) AS AverageCGPA
FROM Student
GROUP BY branch
HAVING AverageCGPA > 8.5;

-- Utilizing existing index structures to optimize sorting operations
SELECT student_id, name, city 
FROM Student 
ORDER BY city;

-- Optimized row limitation (Top 3 Students)
SELECT name, cgpa 
FROM Student 
ORDER BY cgpa DESC 
LIMIT 3;

--------------------------------------------------------------------------------
-- STEP 9 : Database Administration & Statistics Refreshes
--------------------------------------------------------------------------------
-- Updates the query optimizer's metadata engine with fresh index cardinality
ANALYZE TABLE Student;

-- Defragments tablespace allocation to reclaim unused block space
OPTIMIZE TABLE Student;

--------------------------------------------------------------------------------
-- STEP 10 : Efficient Data Modification (DML Best Practices)
-- ANALYSIS: Updates and deletes target indexed keys to ensure performance safety.
--------------------------------------------------------------------------------
UPDATE Student 
SET cgpa = 9.50 
WHERE student_id = 1;

DELETE FROM Student 
WHERE student_id = 6;