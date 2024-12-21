-- PROBLEM STATEMENT: 
-- Find out the employees who attended all the company events.

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Create employees table
CREATE TABLE IF NOT EXISTS employees (
    id INT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL
);

-- Insert data into employees table
INSERT INTO employees (id, emp_name) VALUES
    (1, 'Lewis'),
    (2, 'Max'),
    (3, 'Charles'),
    (4, 'Sainz');

-- Create events table
CREATE TABLE IF NOT EXISTS events (
    event_name VARCHAR(50) NOT NULL,
    emp_id INT NOT NULL,
    event_date DATE NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees (id)
);

-- Insert data into events table
INSERT INTO events (event_name, emp_id, event_date) VALUES
    ('Product launch', 1, TO_DATE('01-03-2024', 'DD-MM-YYYY')),
    ('Product launch', 3, TO_DATE('01-03-2024', 'DD-MM-YYYY')),
    ('Product launch', 4, TO_DATE('01-03-2024', 'DD-MM-YYYY')),
    ('Conference', 2, TO_DATE('02-03-2024', 'DD-MM-YYYY')),
    ('Conference', 2, TO_DATE('03-03-2024', 'DD-MM-YYYY')),
    ('Conference', 3, TO_DATE('02-03-2024', 'DD-MM-YYYY')),
    ('Conference', 4, TO_DATE('02-03-2024', 'DD-MM-YYYY')),
    ('Training', 3, TO_DATE('04-03-2024', 'DD-MM-YYYY')),
    ('Training', 2, TO_DATE('04-03-2024', 'DD-MM-YYYY')),
    ('Training', 4, TO_DATE('04-03-2024', 'DD-MM-YYYY')),
    ('Training', 4, TO_DATE('05-03-2024', 'DD-MM-YYYY'));

-- Select all data from employees table
SELECT * FROM employees;

-- Select all data from events table
SELECT * FROM events;

-- ######################### Solution_1 - PostgreSQL ##########################

-- Solution Name: Employees Attending All Events Using HAVING Clause

-- Description: 
-- This query identifies employees who have attended all the company events by using the HAVING clause. 
-- It ensures that the count of distinct events attended by each employee matches the total number of distinct events.

-- Key Components:
-- 1. Subquery to count the total number of distinct events.
-- 2. Main query to join employees and events tables.
-- 3. HAVING clause to filter employees who attended all events.
-- 4. Grouping by employee ID and name to get the count of distinct events attended by each employee.

-- Notes:
-- This approach ensures that only those employees who have attended every single event are selected.

SELECT 
    e.id,
    e.emp_name AS employee_name,
    COUNT(DISTINCT ev.event_name) AS no_of_events
FROM 
    events ev
    JOIN employees e ON e.id = ev.emp_id
GROUP BY 
    e.id, 
    e.emp_name
HAVING 
    COUNT(DISTINCT ev.event_name) = (
        SELECT COUNT(DISTINCT event_name) 
        FROM events
    );

-- #############################################################################

-- ######################### Solution_2 - PostgreSQL ##########################

-- Solution Name: Employees Attending All Events Using NOT EXISTS

-- Description: 
-- This query identifies employees who have attended all the company events by using a double NOT EXISTS clause. 
-- It ensures that for every event, there is a corresponding entry for each employee in the events table.

-- Key Components:
-- 1. CTE (Common Table Expression) to count the total number of distinct events.
-- 2. Main query to join employees and events tables.
-- 3. Double NOT EXISTS clause to filter employees who attended all events.
-- 4. Grouping by employee ID and name to get the count of distinct events attended by each employee.

-- Notes:
-- This approach ensures that only those employees who have attended every single event are selected.

WITH event_counts AS (
    SELECT COUNT(DISTINCT event_name) AS total_events
    FROM events
)
SELECT 
    e.id,
    e.emp_name AS employee_name,
    COUNT(DISTINCT ev.event_name) AS no_of_events
FROM employees e
JOIN events ev ON e.id = ev.emp_id
WHERE NOT EXISTS (
    SELECT event_name 
    FROM events e1
    WHERE NOT EXISTS (
        SELECT 1 
        FROM events e2 
        WHERE e2.emp_id = e.id 
        AND e2.event_name = e1.event_name
    )
)
GROUP BY e.id, e.emp_name;

-- #############################################################################