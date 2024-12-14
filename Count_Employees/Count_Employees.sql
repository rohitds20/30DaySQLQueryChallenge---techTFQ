CREATE DATABASE 30daychallenge;

USE 30daychallenge;

CREATE TABLE 30daychallenge.employee_managers (
    id INT,
    name VARCHAR(20),
    manager INT
);

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

SELECT * FROM employee_managers;

##################### Solution - MYSQL  ##########################

SELECT 
    mng.name AS manager, 
    COUNT(emp.name) AS employee
FROM 
    employee_managers emp
JOIN 
    employee_managers mng 
ON 
    emp.manager = mng.id
GROUP BY 
    manager
ORDER BY 
    employee DESC;

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
    ec.employee_count AS employee
FROM 
    EmployeeCounts ec
JOIN 
    employee_managers mng 
ON 
    ec.manager = mng.id
ORDER BY 
    ec.employee_count DESC;


##################### Solution - POSTGRESQL  ##########################

SELECT 
    mng.name AS manager, 
    COUNT(emp.name) AS employee
FROM 
    employee_managers emp
JOIN 
    employee_managers mng 
ON 
    emp.manager = mng.id
GROUP BY 
    manager
ORDER BY 
    employee DESC;