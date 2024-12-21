
-- Write a sql query to return the footer values from input table, meaning all the last 
-- non null values from each field as shown in expected output.									

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Create the FOOTER table if it doesn't exist
CREATE TABLE IF NOT EXISTS FOOTER (
    id      INT PRIMARY KEY,
    car     VARCHAR(20), 
    length  INT, 
    width   INT, 
    height  INT
);

-- Insert sample data into the FOOTER table
INSERT INTO FOOTER (id, car, length, width, height) VALUES 
    (1, 'Hyundai Tucson', 15, 6, NULL),
    (2, NULL, NULL, NULL, 20),
    (3, NULL, 12, 8, 15),
    (4, 'Toyota Rav4', NULL, 15, NULL),
    (5, 'Kia Sportage', NULL, NULL, 18);

-- Select all data from the FOOTER table
SELECT * FROM FOOTER;

-- ######################### Solution_1 - PostgreSQL ##########################

-- Solution Name: Fetch Last Non-Null Values Using Window Functions
-- Description: This solution uses window functions to segment the data based on non-null values and then fetches the first value in each segment.
-- Key Components:
--   - Window Functions: SUM and FIRST_VALUE
--   - Common Table Expression (CTE): segmented_footer
-- Notes: This approach ensures that we get the last non-null value for each column by segmenting the data and then ordering it in descending order.

WITH segmented_footer AS (
    SELECT 
        *,
        SUM(CASE WHEN car IS NULL THEN 0 ELSE 1 END) OVER (ORDER BY id) AS car_segment,
        SUM(CASE WHEN length IS NULL THEN 0 ELSE 1 END) OVER (ORDER BY id) AS length_segment,
        SUM(CASE WHEN width IS NULL THEN 0 ELSE 1 END) OVER (ORDER BY id) AS width_segment,
        SUM(CASE WHEN height IS NULL THEN 0 ELSE 1 END) OVER (ORDER BY id) AS height_segment
    FROM 
        footer
)
SELECT 
    FIRST_VALUE(car) OVER (PARTITION BY car_segment ORDER BY id) AS car_first,
    FIRST_VALUE(length) OVER (PARTITION BY length_segment ORDER BY id) AS length_first,
    FIRST_VALUE(width) OVER (PARTITION BY width_segment ORDER BY id) AS width_first,
    FIRST_VALUE(height) OVER (PARTITION BY height_segment ORDER BY id) AS height_first
FROM 
    segmented_footer
ORDER BY 
    id DESC
LIMIT 1;

-- #############################################################################

-- ######################### Solution_2 - PostgreSQL  ##########################

-- Solution Name: Fetch Last Non-Null Values Using Subqueries
-- Description: This solution uses subqueries to find the last non-null value for each column by identifying the maximum id where the column is not null.
-- Key Components:
--   - Common Table Expression (CTE): last_non_nulls
--   - Subqueries: To fetch the last non-null value for each column
-- Notes: This approach ensures that we get the last non-null value for each column by using subqueries to fetch the values based on the maximum id.

WITH last_non_nulls AS (
    SELECT 
        MAX(id) FILTER (WHERE car IS NOT NULL) AS last_car_id,
        MAX(id) FILTER (WHERE length IS NOT NULL) AS last_length_id,
        MAX(id) FILTER (WHERE width IS NOT NULL) AS last_width_id,
        MAX(id) FILTER (WHERE height IS NOT NULL) AS last_height_id
    FROM 
        FOOTER
)
SELECT 
    (SELECT car FROM FOOTER WHERE id = last_car_id) AS car_last,
    (SELECT length FROM FOOTER WHERE id = last_length_id) AS length_last,
    (SELECT width FROM FOOTER WHERE id = last_width_id) AS width_last,
    (SELECT height FROM FOOTER WHERE id = last_height_id) AS height_last
FROM 
    last_non_nulls;

-- #############################################################################