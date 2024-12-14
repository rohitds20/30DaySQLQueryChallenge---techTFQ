CREATE 30daychallenge;

USE 30daychallenge;


CREATE TABLE IF NOT EXISTS 30daychallenge.EmployeeData
(
    id         INT,
    name       VARCHAR(20),
    location   VARCHAR(20)
);

INSERT INTO 30daychallenge.EmployeeData (id, name, location) 
VALUES 
    (1, NULL, NULL),
    (2, 'David', NULL),
    (3, NULL, 'London'),
    (4, NULL, NULL),
    (5, 'David', NULL);


SELECT * FROM 30daychallenge.EmployeeData;

##################### Solution - MYSQL  ##########################
-- This script contains two SQL queries that operate on the EmployeeData table.
-- The first query selects the minimum values of id, name, and location from the EmployeeData table.
-- The second query selects the maximum value of id, and the minimum values of name and location from the EmployeeData table.
SELECT 
	MIN(id) as id,
	MIN(name) as name,
	MIN(location) as location
FROM EmployeeData;

SELECT 
	MAX(id) as id,
	MIN(name) as name,
	MIN(location) as location
FROM EmployeeData;