-- Problem Statement:					
-- Given a table containing client information, vehicle details, repair dates, indicators, 
-- and values, write a SQL query to transform this data into a summary table based on certain conditions.

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";


-- Create the auto_repair table if it doesn't exist
CREATE TABLE IF NOT EXISTS auto_repair (
    client        VARCHAR(20),
    auto          VARCHAR(20),
    repair_date   INT,
    indicator     VARCHAR(20),
    value         VARCHAR(20)
);

-- Insert sample data into the auto_repair table
INSERT INTO auto_repair (client, auto, repair_date, indicator, value) VALUES
    ('c1', 'a1', 2022, 'level', 'good'),
    ('c1', 'a1', 2022, 'velocity', '90'),
    ('c1', 'a1', 2023, 'level', 'regular'),
    ('c1', 'a1', 2023, 'velocity', '80'),
    ('c1', 'a1', 2024, 'level', 'wrong'),
    ('c1', 'a1', 2024, 'velocity', '70'),
    ('c2', 'a1', 2022, 'level', 'good'),
    ('c2', 'a1', 2022, 'velocity', '90'),
    ('c2', 'a1', 2023, 'level', 'wrong'),
    ('c2', 'a1', 2023, 'velocity', '50'),
    ('c2', 'a2', 2024, 'level', 'good'),
    ('c2', 'a2', 2024, 'velocity', '80');

-- Select all data from the auto_repair table
SELECT * FROM auto_repair;

-- ######################### Solution_1 - PostgreSQL  ##########################
-- Solution Name: Summarize Levels by Velocity
-- Description: This query summarizes the count of different levels (good, wrong, regular) for each velocity value.
-- Key Components:
--   - Subquery to pair velocity with corresponding level for each client, auto, and repair_date.
--   - Aggregation to count occurrences of each level type for each velocity.
-- Notes: Uses a subquery to fetch level values corresponding to each velocity entry.

SELECT 
    velocity AS velocity,
    SUM(CASE WHEN level = 'good' THEN 1 ELSE 0 END) AS good,
    SUM(CASE WHEN level = 'wrong' THEN 1 ELSE 0 END) AS wrong,
    SUM(CASE WHEN level = 'regular' THEN 1 ELSE 0 END) AS regular
FROM (
    SELECT 
        value AS velocity,
        (SELECT value FROM auto_repair t2 
         WHERE t2.client = t1.client 
           AND t2.auto = t1.auto 
           AND t2.repair_date = t1.repair_date 
           AND t2.indicator = 'level') AS level
    FROM auto_repair t1
    WHERE t1.indicator = 'velocity'
) AS subquery
GROUP BY velocity
ORDER BY velocity;

-- #############################################################################

-- ######################### Solution_2 - PostgreSQL  ##########################
-- Solution Name: Summarize Levels by Velocity with Join
-- Description: This query summarizes the count of different levels (good, wrong, regular) for each velocity value using a join.
-- Key Components:
--   - Join to pair velocity with corresponding level for each client, auto, and repair_date.
--   - Aggregation to count occurrences of each level type for each velocity.
-- Notes: Uses a join to fetch level values corresponding to each velocity entry.

SELECT 
    t1.value AS velocity,
    SUM(CASE WHEN t2.value = 'good' THEN 1 ELSE 0 END) AS good,
    SUM(CASE WHEN t2.value = 'wrong' THEN 1 ELSE 0 END) AS wrong,
    SUM(CASE WHEN t2.value = 'regular' THEN 1 ELSE 0 END) AS regular
FROM auto_repair t1
JOIN auto_repair t2 ON t1.client = t2.client 
                    AND t1.auto = t2.auto 
                    AND t1.repair_date = t2.repair_date
                    AND t2.indicator = 'level'
WHERE t1.indicator = 'velocity'
GROUP BY t1.value
ORDER BY t1.value;

-- #############################################################################