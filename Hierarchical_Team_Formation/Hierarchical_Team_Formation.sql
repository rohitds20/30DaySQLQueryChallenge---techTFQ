CREATE DATABASE 30daychallenge;

USE 30daychallenge;

CREATE TABLE IF NOT EXISTS company (
    employee VARCHAR(10) PRIMARY KEY,
    manager  VARCHAR(10)
);

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

SELECT * FROM company;

##################### Solution - MYSQL  ########################## 

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
    GROUP_CONCAT(employee ORDER BY level, employee SEPARATOR ', ') AS members
FROM 
    hierarchy 
GROUP BY 
    teams
ORDER BY 
    teams;

##################### Solution - POSTGRESQL  ########################## 

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