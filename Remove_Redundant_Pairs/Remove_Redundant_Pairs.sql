/* Problem Statement:
- For pairs of brands in the same year (e.g. apple/samsung/2020 and samsung/apple/2020) 
    - if custom1 = custom3 and custom2 = custom4 : then keep only one pair

- For pairs of brands in the same year 
    - if custom1 != custom3 OR custom2 != custom4 : then keep both pairs

- For brands that do not have pairs in the same year : keep those rows as well
*/

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Create the brands table if it doesn't exist
CREATE TABLE IF NOT EXISTS brands (
    brand1      VARCHAR(20),
    brand2      VARCHAR(20),
    year        INT,
    custom1     INT,
    custom2     INT,
    custom3     INT,
    custom4     INT
);

-- Insert sample data into the brands table
INSERT INTO brands (brand1, brand2, year, custom1, custom2, custom3, custom4) VALUES 
('apple', 'samsung', 2020, 1, 2, 1, 2),
('samsung', 'apple', 2020, 1, 2, 1, 2),
('apple', 'samsung', 2021, 1, 2, 5, 3),
('samsung', 'apple', 2021, 5, 3, 1, 2),
('google', NULL, 2020, 5, 9, NULL, NULL),
('oneplus', 'nothing', 2020, 5, 9, 6, 3);

-- Select all data from the brands table
SELECT * FROM brands;

-- ######################### Solution_1 - PostgreSQL  ##########################
-- Solution Name: Remove Redundant Pairs
-- Description: This query removes redundant pairs of brands in the same year where custom1 = custom3 and custom2 = custom4, keeping only one pair. If custom1 != custom3 OR custom2 != custom4, both pairs are kept. Brands without pairs in the same year are also retained.
-- Key Components:
-- 1. brand_pairs CTE: Creates a unique identifier for each pair of brands in the same year.
-- 2. unique_pairs CTE: Assigns a row number to each pair based on the unique identifier.
-- 3. Final SELECT: Filters the pairs to remove redundancy based on the row number and custom values.
-- Notes: This solution uses Common Table Expressions (CTEs) and window functions to achieve the desired result.

WITH brand_pairs AS (
    SELECT
        *,
        CASE
            WHEN brand1 < brand2 THEN CONCAT(brand1, brand2, year::TEXT)
            ELSE CONCAT(brand2, brand1, year::TEXT)
        END AS pair_id
    FROM
        brands
),
unique_pairs AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY pair_id ORDER BY pair_id) AS rn
    FROM
        brand_pairs
)
SELECT
    brand1,
    brand2,
    year,
    custom1,
    custom2,
    custom3,
    custom4
FROM
    unique_pairs
WHERE
    rn = 1 OR (custom1 <> custom3 AND custom2 <> custom4);

-- #############################################################################

-- ######################### Solution_2 - PostgreSQL  ##########################
-- Solution Name: Remove Redundant Pairs
-- Description: This query removes redundant pairs of brands in the same year where custom1 = custom3 and custom2 = custom4, keeping only one pair. If custom1 != custom3 OR custom2 != custom4, both pairs are kept. Brands without pairs in the same year are also retained.
-- Key Components:
-- 1. Subquery: Creates a unique identifier for each pair of brands in the same year and assigns a row number to each pair based on the unique identifier.
-- 2. Final SELECT: Filters the pairs to remove redundancy based on the row number and custom values.
-- Notes: This solution uses a subquery and window functions to achieve the desired result.

SELECT
    brand1,
    brand2,
    year,
    custom1,
    custom2,
    custom3,
    custom4
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY 
            CASE
                WHEN brand1 < brand2 THEN CONCAT(brand1, brand2, year)
                ELSE CONCAT(brand2, brand1, year)
            END 
            ORDER BY 
            CASE
                WHEN brand1 < brand2 THEN CONCAT(brand1, brand2, year)
                ELSE CONCAT(brand2, brand1, year)
            END) AS rn
    FROM
        brands
) AS unique_pairs
WHERE
    rn = 1 OR (custom1 <> custom3 AND custom2 <> custom4);

-- #############################################################################