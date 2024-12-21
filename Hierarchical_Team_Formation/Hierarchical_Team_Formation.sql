-- PROBLEM STATEMENT: 
-- Given graph shows the hierarchy of employees in a company. 
-- Write an SQL query to split the hierarchy and show the employees corresponding to their team.

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Create the company table if it doesn't exist
CREATE TABLE IF NOT EXISTS company (
    employee VARCHAR(10),
    manager  VARCHAR(10)
);

-- Insert data into the company table
INSERT INTO company (employee, manager) VALUES
    ('Elon', NULL),
    ('Ira', 'Elon'),
    ('Bret', 'Elon'),
    ('Earl', 'Elon'),
    ('James', 'Ira'),
    ('Drew', 'Ira'),
    ('Mark', 'Bret'),
    ('Phil', 'Mark'),
    ('Jon', 'Mark'),
    ('Omid', 'Earl');

-- Select all data from the company table
SELECT * FROM company;

-- ######################### Solution_1 - PostgreSQL  ##########################
-- Solution Name: Hierarchical Team Formation
-- Description: This query identifies the hierarchical structure of employees in a company and groups them into teams based on their managers.
-- Key Components:
-- 1. Recursive CTE (Common Table Expression) to traverse the hierarchy.
-- 2. ROW_NUMBER() function to assign team numbers.
-- 3. STRING_AGG() function to concatenate team members.
-- Notes: Ensure the company table is populated with the correct hierarchical data before running the query.

WITH RECURSIVE team_leaders AS (
    SELECT 
        mng.employee, 
        CONCAT('Team ', ROW_NUMBER() OVER(ORDER BY mng.employee)) AS teams
    FROM 
        company root
    JOIN 
        company mng ON root.employee = mng.manager
    WHERE 
        root.manager IS NULL
),
hierarchy AS (
    SELECT 
        c.employee, 
        c.manager, 
        t.teams,
        1 AS level
    FROM 
        company c
    CROSS JOIN 
        team_leaders t 
    WHERE 
        c.manager IS NULL
    UNION 
    SELECT 
        c.employee, 
        c.manager,
        COALESCE(t.teams, hierarchy.teams) AS teams,
        hierarchy.level + 1 AS level
    FROM 
        company c
    JOIN 
        hierarchy ON hierarchy.employee = c.manager
    LEFT JOIN 
        team_leaders t ON t.employee = c.employee
)
SELECT 
    teams, 
    STRING_AGG(employee, ', ' ORDER BY level, employee) AS members
FROM 
    hierarchy 
GROUP BY 
    teams
ORDER BY 
    teams;

-- #############################################################################