CREATE DATABASE 30daychallenge;

USE 30daychallenge;

CREATE TABLE IF NOT EXISTS 30daychallenge.FOOTER (
    id      INT PRIMARY KEY,
    car     VARCHAR(20), 
    length  INT, 
    width   INT, 
    height  INT
);

INSERT INTO 30daychallenge.FOOTER (id, car, length, width, height) VALUES 
    (1, 'Hyundai Tucson', 15, 6, NULL),
    (2, NULL, NULL, NULL, 20),
    (3, NULL, 12, 8, 15),
    (4, 'Toyota Rav4', NULL, 15, NULL),
    (5, 'Kia Sportage', NULL, NULL, 18);

SELECT * FROM 30daychallenge.FOOTER;

##################### Solution - MYSQL  ##########################

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


-- SELECT *
-- FROM (SELECT car FROM FOOTER WHERE car IS NOT NULL ORDER BY id DESC LIMIT 1) car
-- CROSS JOIN (SELECT length FROM FOOTER WHERE length IS NOT NULL ORDER BY id DESC LIMIT 1) length
-- CROSS JOIN (SELECT width FROM FOOTER WHERE width IS NOT NULL ORDER BY id DESC LIMIT 1) width
-- CROSS JOIN (SELECT height FROM FOOTER WHERE height IS NOT NULL ORDER BY id DESC LIMIT 1) height;
