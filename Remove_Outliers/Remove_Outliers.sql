CREATE DATABASE 30daychallenge;

USE 30daychallenge;

CREATE TABLE IF NOT EXISTS hotel_ratings (
    hotel VARCHAR(30),
    year INT,
    rating DECIMAL(3, 1) -- 3 digits total, 1 after the decimal point
);

INSERT INTO hotel_ratings (hotel, year, rating) VALUES
    ('Radisson Blu', 2020, 4.8),
    ('Radisson Blu', 2021, 3.5),
    ('Radisson Blu', 2022, 3.2),
    ('Radisson Blu', 2023, 3.8),
    ('InterContinental', 2020, 4.2),
    ('InterContinental', 2021, 4.5),
    ('InterContinental', 2022, 1.5),
    ('InterContinental', 2023, 3.8);

SELECT * FROM hotel_ratings;

##################### Solution - MYSQL  ##########################

WITH AvgRatings AS (
	SELECT 
		*, 
		ROUND(AVG(rating) OVER(PARTITION BY hotel ORDER BY year RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 2) AS avg_rating
	FROM 
		hotel_ratings
),
RankedRatings AS (
	SELECT 
		*, 
		ABS(avg_rating - rating) AS rating_diff,
		RANK() OVER(PARTITION BY hotel ORDER BY ABS(avg_rating - rating) DESC) AS rating_deviation_rank
	FROM 
		AvgRatings
)
SELECT 
	hotel, 
	year, 
	rating
FROM 
	RankedRatings
WHERE 
	rating_deviation_rank > 1
ORDER BY 
	hotel, 
	year
;


-- SELECT 
--     hotel, 
--     year, 
--     rating
-- FROM (
--     SELECT 
--         hotel, 
--         year, 
--         rating,
--         avg_rating,
--         ABS(avg_rating - rating) AS rating_diff,
--         RANK() OVER(PARTITION BY hotel ORDER BY ABS(avg_rating - rating) DESC) AS rating_deviation_rank
--     FROM (
--         SELECT 
--             hotel, 
--             year, 
--             rating,
--             ROUND(AVG(rating) OVER(PARTITION BY hotel ORDER BY year RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 2) AS avg_rating
--         FROM 
--             hotel_ratings
--     ) AS AvgRatings
-- ) AS RankedRatings
-- WHERE 
--     rating_deviation_rank > 1
-- ORDER BY 
--     hotel, 
--     year;