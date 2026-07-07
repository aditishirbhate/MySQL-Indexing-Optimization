/*==============================================================================
 PROJECT     : MySQL Database Indexing and Optimization
 AUTHOR      : Aditi Shirbhate
 PURPOSE     : Demonstrate Advanced MySQL Optimization, Indexing, and 
               Stored Procedures while maintaining DRY principles.
==============================================================================*/

--------------------------------------------------------------------------------
-- STEP 1 : Database Initialization & Schema Design
--------------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS CollegeDB;
USE CollegeDB;

-- Drop existing tables to ensure a clean, reproducible test environment
DROP TABLE IF EXISTS Student;

-- Table optimized with appropriate naming conventions and strict constraints
CREATE TABLE Student (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    email_address VARCHAR(100) NOT NULL UNIQUE, -- Internal unique index created
    branch_name VARCHAR(50) NOT NULL,
    city_name VARCHAR(50) NOT NULL,
    student_age INT NOT NULL CHECK (student_age >= 18),
    current_cgpa DECIMAL(3,2) NOT NULL
);

--------------------------------------------------------------------------------
-- STEP 2 : Data Population (DRY Compliant Seeding Stored Procedure)
--------------------------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE sp_SeedStudentData()
BEGIN
    -- Insert clean, foundational benchmark records safely
    INSERT INTO Student (student_name, email_address, branch_name, city_name, student_age, current_cgpa)
    VALUES
    ('Aditi', 'aditi@gmail.com', 'CSE', 'Nagpur', 21, 8.90),
    ('Rahul', 'rahul@gmail.com', 'IT', 'Pune', 22, 8.30),
    ('Sneha', 'sneha@gmail.com', 'CSE', 'Mumbai', 20, 9.10),
    ('Rohan', 'rohan@gmail.com', 'ECE', 'Delhi', 23, 8.00),
    ('Neha', 'neha@gmail.com', 'IT', 'Nagpur', 21, 8.70),
    ('Priya', 'priya@gmail.com', 'CSE', 'Nagpur', 20, 9.40);
END$$

DELIMITER ;

-- Execute data seed procedure
CALL sp_SeedStudentData();

--------------------------------------------------------------------------------
-- STEP 3 : Optimization Procedures (Encapsulating Core Logic for DRY Compliance)
--------------------------------------------------------------------------------
DELIMITER $$

-- Procedure to fetch student records safely without using resource-heavy 'SELECT *'
CREATE PROCEDURE sp_GetStudentsByCity(IN target_city VARCHAR(50))
BEGIN
    SELECT student_id, student_name, branch_name, current_cgpa 
    FROM Student 
    WHERE city_name = target_city;
END$$

-- Procedure to apply indexing dynamically and refresh database statistics
CREATE PROCEDURE sp_ApplyPerformanceIndexes()
BEGIN
    -- Single-column standard index for geographic lookups
    CREATE INDEX idx_city_name ON Student(city_name);
    
    -- Composite index optimized for multi-conditional filtering
    CREATE INDEX idx_branch_city ON Student(branch_name, city_name);
    
    -- Force optimizer data refresh
    ANALYZE TABLE Student;
END$$

-- Procedure to maintain table structures and clean up storage fragmentation
CREATE PROCEDURE sp_MaintainTableHealth()
BEGIN
    ANALYZE TABLE Student;
    OPTIMIZE TABLE Student;
END$$

DELIMITER ;

--------------------------------------------------------------------------------
-- STEP 4 : Performance Evaluation & Execution Plan Analysis (Critical Benchmark)
--------------------------------------------------------------------------------

-- [A] PERFORMANCE BEFORE INDEXING:
-- ANALYSIS: This statement will trigger a Full Table Scan (type: ALL) because 
-- the database optimizer does not yet have a specialized index path for 'city_name'.
EXPLAIN 
SELECT student_id, student_name, branch_name, current_cgpa 
FROM Student 
WHERE city_name = 'Nagpur';


-- [B] APPLY OPTIMIZATION:
-- Execute the procedure to construct our B-Tree structural lookups
CALL sp_ApplyPerformanceIndexes();


-- [C] PERFORMANCE AFTER INDEXING:
-- ANALYSIS: Running the exact same query now shows an execution type of 'ref' 
-- using 'idx_city_name'. The rows processed drop significantly, showing true optimization.
EXPLAIN 
SELECT student_id, student_name, branch_name, current_cgpa 
FROM Student 
WHERE city_name = 'Nagpur';

--------------------------------------------------------------------------------
-- STEP 5 : Execution of Production Operations via Stored Routines
--------------------------------------------------------------------------------

-- Call optimized data retrieval routine
CALL sp_GetStudentsByCity('Nagpur');

-- View all structurally registered database indexes for validation
SHOW INDEX FROM Student;

-- Run administrative optimizations to wrap up the project deployment phase
CALL sp_MaintainTableHealth();