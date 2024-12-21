-- PROBLEM STATEMENT:
-- Find out the number of employees managed by each manager.

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Create the 'employee_managers' table
CREATE TABLE IF NOT EXISTS employee_managers (
    id INT,
    name VARCHAR(20),
    manager INT
);

-- Insert data into the 'employee_managers' table
INSERT INTO employee_managers (id, name, manager) VALUES 
(1, 'Sundar', NULL),
(2, 'Kent', 1),
(3, 'Ruth', 1),
(4, 'Alison', 1),
(5, 'Clay', 2),
(6, 'Ana', 2),
(7, 'Philipp', 3),
(8, 'Prabhakar', 4),
(9, 'Hiroshi', 4),
(10, 'Jeff', 4),
(11, 'Thomas', 1),
(12, 'John', 15),
(13, 'Susan', 15),
(14, 'Lorraine', 15),
(15, 'Larry', 1);

-- Select all data from the 'employee_managers' table
SELECT * FROM employee_managers;

-- ######################### Solution 1: Using CTE ##########################

-- Description: This solution uses a Common Table Expression (CTE) to first count the number of 
-- employees for each manager and then joins the result with the employee_managers table to get the manager names.

-- Notes: This approach is useful for breaking down complex queries into simpler parts using CTEs.

WITH EmployeeCounts AS (
    SELECT 
        manager, 
        COUNT(*) AS employee_count
    FROM 
        employee_managers
    WHERE 
        manager IS NOT NULL
    GROUP BY 
        manager
)
SELECT 
    mng.name AS manager, 
    ec.employee_count AS no_of_employees
FROM 
    EmployeeCounts ec
JOIN 
    employee_managers mng 
ON 
    ec.manager = mng.id
ORDER BY 
    ec.employee_count DESC;

-- #########################################################################

-- ######################### Solution 2: Direct Join ##########################

-- Description: This solution directly joins the employee_managers table with itself to 
-- count the number of employees for each manager.

-- Notes: This approach is straightforward and uses a direct join and aggregation to achieve the result.

SELECT 
    mng.name AS manager, 
    COUNT(emp.name) AS no_of_employees
FROM 
    employee_managers emp
JOIN 
    employee_managers mng 
ON 
    emp.manager = mng.id
GROUP BY 
    mng.name
ORDER BY 
    no_of_employees DESC;

-- #########################################################################