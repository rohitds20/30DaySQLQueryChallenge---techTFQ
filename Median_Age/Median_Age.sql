-- Problem Statement:
-- Find the median ages of countries.

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Create a new table named 'people' if it doesn't exist already
CREATE TABLE IF NOT EXISTS people (
    id SERIAL PRIMARY KEY,
    country VARCHAR(20),
    age INT
);

-- Insert sample data into the 'people' table
INSERT INTO people (country, age) VALUES
('Poland', 10),
('Poland', 5),
('Poland', 34),
('Poland', 56),
('Poland', 45),
('Poland', 60),
('India', 18),
('India', 15),
('India', 33),
('India', 38),
('India', 40),
('India', 50),
('USA', 20),
('USA', 23),
('USA', 32),
('USA', 54),
('USA', 55),
('Japan', 65),
('Japan', 6),
('Japan', 58),
('Germany', 54),
('Germany', 6),
('Malaysia', 44);

-- Select all data from the 'people' table
SELECT * FROM people;

-- ######################### Solution_1 - PostgreSQL  ##########################

/*
Description: Uses Common Table Expression (CTE) to calculate median
Key Components:
- Uses ROW_NUMBER() for ranking ages within each country
- Calculates total count per country
- Handles both odd and even number of records
Note: More readable approach with separated logic
*/

WITH ranked_ages AS (
     SELECT
          COUNTRY,
          AGE,
          ROW_NUMBER() OVER (PARTITION BY COUNTRY ORDER BY AGE) AS row_num,
          COUNT(*) OVER (PARTITION BY COUNTRY) AS total_count
     FROM people
)
SELECT 
     COUNTRY,
     AGE
FROM ranked_ages
WHERE row_num IN (
     (total_count + 1) / 2,
     total_count / 2 + 1
)
ORDER BY COUNTRY, AGE;

-- #############################################################################

-- ######################### Solution_2 - PostgreSQL ##########################
/*
Description: Uses Subquery approach to calculate median
Key Components:
- Similar logic to Solution 1 but uses subquery instead of CTE
- More traditional SQL approach
Note: Might be more performant in some database engines
*/

SELECT 
     COUNTRY,
     AGE
FROM (
     SELECT
          COUNTRY,
          AGE,
          ROW_NUMBER() OVER (PARTITION BY COUNTRY ORDER BY AGE) AS row_num,
          COUNT(*) OVER (PARTITION BY COUNTRY) AS total_count
     FROM people
) AS ranked_ages
WHERE row_num IN (
     (total_count + 1) / 2,
     total_count / 2 + 1
)
ORDER BY COUNTRY, AGE;

-- #############################################################################