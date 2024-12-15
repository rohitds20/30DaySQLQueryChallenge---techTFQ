CREATE DATABASE 30daychallenge;

USE 30daychallenge;

CREATE TABLE IF NOT EXISTS employees (
    id INT,
    emp_name VARCHAR(50)
);

INSERT INTO  employees(id, emp_name)  VALUES
    (1, 'Lewis'),
    (2, 'Max'),
    (3, 'Charles'),
    (4, 'Sainz');


CREATE TABLE IF NOT EXISTS events (
    event_name VARCHAR(50),
    emp_id INT,
    dates DATE
);

INSERT INTO  events(event_name, emp_id, dates)  VALUES
    ('Product launch', 1, str_to_date('01-03-2024','%d-%m-%Y')),
    ('Product launch', 3, str_to_date('01-03-2024','%d-%m-%Y')),
    ('Product launch', 4, str_to_date('01-03-2024','%d-%m-%Y')),
    ('Conference', 2, str_to_date('02-03-2024','%d-%m-%Y')),
    ('Conference', 2, str_to_date('03-03-2024','%d-%m-%Y')),
    ('Conference', 3, str_to_date('02-03-2024','%d-%m-%Y')),
    ('Conference', 4, str_to_date('02-03-2024','%d-%m-%Y')),
    ('Training', 3, str_to_date('04-03-2024','%d-%m-%Y')),
    ('Training', 2, str_to_date('04-03-2024','%d-%m-%Y')),
    ('Training', 4, str_to_date('04-03-2024','%d-%m-%Y')),
    ('Training', 4, str_to_date('05-03-2024','%d-%m-%Y'));


SELECT * FROM employees;
SELECT * FROM events;

##################### Solution - MYSQL  ##########################

SELECT 
    e.id,
    e.emp_name AS employee_name,
    COUNT(DISTINCT event_name) AS no_of_events
FROM 
    events ev
    JOIN employees e ON e.id = ev.emp_id
GROUP BY 
    e.id, 
    e.emp_name
HAVING 
    COUNT(DISTINCT event_name) = (
        SELECT COUNT(DISTINCT event_name) 
        FROM events
    );

    -- WITH event_counts AS (
    --     SELECT COUNT(DISTINCT event_name) as total_events
    --     FROM events
    -- )
    -- SELECT 
    --     e.id,
    --     e.emp_name AS employee_name,
    --     COUNT(DISTINCT ev.event_name) AS no_of_events
    -- FROM employees e
    -- JOIN events ev ON e.id = ev.emp_id
    -- WHERE NOT EXISTS (
    --     SELECT event_name 
    --     FROM events e1
    --     WHERE NOT EXISTS (
    --         SELECT 1 
    --         FROM events e2 
    --         WHERE e2.emp_id = e.id 
    --         AND e2.event_name = e1.event_name
    --     )
    -- )
    -- GROUP BY e.id, e.emp_name;