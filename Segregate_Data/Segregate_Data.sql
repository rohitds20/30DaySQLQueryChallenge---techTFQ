-- Problem Statement:					
-- Write a query to get the minimum id, name and location from the table EmployeeData.

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Create the EmployeeData table if it doesn't exist
CREATE TABLE IF NOT EXISTS EmployeeData (
    id         INT,
    name       VARCHAR(20),
    location   VARCHAR(20)
);

-- Insert data into the EmployeeData table
INSERT INTO EmployeeData (id, name, location) 
VALUES 
    (1, NULL, NULL),
    (2, 'David', NULL),
    (3, NULL, 'London'),
    (4, NULL, NULL),
    (5, 'David', NULL);

-- Select all data from the EmployeeData table
SELECT * FROM EmployeeData;

-- ######################### Solution_1 - PostgreSQL  ##########################
-- Solution Name: Segregate Data using MIN and MAX
-- Description: This solution uses the MIN and MAX functions to get the minimum and maximum values for id, name, and location.
-- Key Components:
--   - MIN(id), MIN(name), MIN(location): Gets the minimum values for id, name, and location.
--   - MAX(id), MAX(name), MAX(location): Gets the maximum values for id, name, and location.
-- Notes: This solution is simple and straightforward, but it may not handle NULL values as expected.

SELECT 
	MIN(id) as id,
	MIN(name) as name,
	MIN(location) as location
FROM EmployeeData;

SELECT 
	MAX(id) as id,
	MAX(name) as name,
	MAX(location) as location
FROM EmployeeData;

-- #############################################################################