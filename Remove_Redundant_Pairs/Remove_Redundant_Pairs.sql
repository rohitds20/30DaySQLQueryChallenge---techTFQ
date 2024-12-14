/* Problem Statement:
- For pairs of brands in the same year (e.g. apple/samsung/2020 and samsung/apple/2020) 
    - if custom1 = custom3 and custom2 = custom4 : then keep only one pair

- For pairs of brands in the same year 
    - if custom1 != custom3 OR custom2 != custom4 : then keep both pairs

- For brands that do not have pairs in the same year : keep those rows as well
*/

CREATE 30daychallenge;

USE 30daychallenge;

CREATE TABLE IF NOT EXISTS 30daychallenge.brands 
(
    brand1      VARCHAR(20),
    brand2      VARCHAR(20),
    year        INT,
    custom1     INT,
    custom2     INT,
    custom3     INT,
    custom4     INT
);

INSERT INTO 30daychallenge.brands (brand1, brand2, year, custom1, custom2, custom3, custom4) VALUES 
('apple', 'samsung', 2020, 1, 2, 1, 2),
('samsung', 'apple', 2020, 1, 2, 1, 2),
('apple', 'samsung', 2021, 1, 2, 5, 3),
('samsung', 'apple', 2021, 5, 3, 1, 2),
('google', NULL, 2020, 5, 9, NULL, NULL),
('oneplus', 'nothing', 2020, 5, 9, 6, 3);

SELECT * FROM 30daychallenge.brands;

##################### Solution - MYSQL  ##########################

WITH brand_pairs AS (
    SELECT
        *,
        CASE
            WHEN brand1 < brand2 THEN CONCAT(brand1, brand2, year)
            ELSE CONCAT(brand2, brand1, year)
        END AS pair_id
    FROM
        30daychallenge.brands
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

-- SELECT
--     brand1,
--     brand2,
--     year,
--     custom1,
--     custom2,
--     custom3,
--     custom4
-- FROM (
--     SELECT
--         *,
--         ROW_NUMBER() OVER (PARTITION BY 
--             CASE
--                 WHEN brand1 < brand2 THEN CONCAT(brand1, brand2, year)
--                 ELSE CONCAT(brand2, brand1, year)
--             END 
--             ORDER BY 
--             CASE
--                 WHEN brand1 < brand2 THEN CONCAT(brand1, brand2, year)
--                 ELSE CONCAT(brand2, brand1, year)
--             END) AS rn
--     FROM
--         30daychallenge.brands
-- ) AS unique_pairs
-- WHERE
--     rn = 1 OR (custom1 <> custom3 AND custom2 <> custom4);

##################### Solution - MYSQL  ##########################

WITH brand_pairs AS (
    SELECT
        *,
        CASE
            WHEN brand1 < brand2 THEN brand1 + brand2 + CAST(year AS VARCHAR)
            ELSE brand2 + brand1 + CAST(year AS VARCHAR)
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

##################### Solution - PostgreSQL  ##########################

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
