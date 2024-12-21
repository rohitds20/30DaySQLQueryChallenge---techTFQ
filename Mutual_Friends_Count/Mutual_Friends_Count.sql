-- PROBLEM STATEMENT: 
-- For the given friends, find the no of mutual friends between them.

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Create the 'friends' table if it doesn't exist
CREATE TABLE IF NOT EXISTS friends (
    friend1 VARCHAR(10),
    friend2 VARCHAR(10)
);

-- Insert sample data into the 'friends' table
INSERT INTO friends (friend1, friend2) VALUES 
('Jason', 'Mary'),
('Mike', 'Mary'),
('Mike', 'Jason'),
('Susan', 'Jason'),
('John', 'Mary'),
('Susan', 'Mary');

-- Select all data from the 'friends' table
SELECT * FROM friends;

-- ######################### Solution_1 - PostgreSQL  ##########################
-- Solution Name: Mutual Friends Count - Solution 1
-- Description: This query calculates the number of mutual friends between pairs of friends.
-- Key Components:
-- 1. CTE (Common Table Expression) 'all_friends' to list all friend pairs in both directions.
-- 2. LEFT JOIN to find mutual friends.
-- 3. Subquery to match mutual friends.
-- 4. GROUP BY and COUNT to aggregate the mutual friends count.
-- Notes: This solution uses a subquery in the JOIN condition to find mutual friends.

WITH all_friends AS (
    SELECT friend1, friend2 FROM friends
    UNION 
    SELECT friend2, friend1 FROM friends
)
SELECT 
    f.friend1, 
    f.friend2,
    COUNT(cf.friend1) AS mutual_friends
FROM 
    friends f
LEFT JOIN 
    all_friends cf 
    ON f.friend1 = cf.friend1
    AND cf.friend2 IN (
        SELECT cf2.friend2
        FROM all_friends cf2
        WHERE f.friend2 = cf2.friend1
    )
GROUP BY 
    f.friend1, f.friend2
ORDER BY 
    f.friend1, f.friend2;

-- #############################################################################

-- ######################### Solution_2 - PostgreSQL  ##########################
-- Solution Name: Mutual Friends Count - Solution 2
-- Description: This query calculates the number of mutual friends between pairs of friends.
-- Key Components:
-- 1. CTE (Common Table Expression) 'all_friends' to list all friend pairs in both directions.
-- 2. JOIN to find mutual friends.
-- 3. GROUP BY and COUNT to aggregate the mutual friends count.
-- Notes: This solution uses a JOIN to find mutual friends directly.

WITH all_friends AS (
    SELECT friend1, friend2 FROM friends
    UNION
    SELECT friend2, friend1 FROM friends
)
SELECT 
    f.friend1, 
    f.friend2,
    COUNT(mf.mutual_friend) AS mutual_friends
FROM 
    friends f
LEFT JOIN (
    SELECT 
        af1.friend1 AS person1,
        af1.friend2 AS mutual_friend,
        af2.friend1 AS person2
    FROM 
        all_friends af1
    JOIN 
        all_friends af2
        ON af1.friend2 = af2.friend2
        AND af1.friend1 <> af2.friend1
) mf
ON f.friend1 = mf.person1
AND f.friend2 = mf.person2
GROUP BY 
    f.friend1, f.friend2
ORDER BY 
    f.friend1, f.friend2;

-- #############################################################################

