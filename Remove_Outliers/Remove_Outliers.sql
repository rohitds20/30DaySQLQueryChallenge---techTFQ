-- PROBLEM STATEMENT: 
-- In the given input table, there are hotel ratings which are either too high or too low 
-- compared to the standard ratings the hotel receives each year. Write a query to identify 
-- and exclude these outlier records. 
-- The standard rating for each hotel is the average of all the ratings it has received over the years.

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Create the hotel_ratings table and insert sample data
CREATE TABLE IF NOT EXISTS hotel_ratings (
	hotel VARCHAR(30),
	year INT,
	rating DECIMAL(3, 1) -- 3 digits total, 1 after the decimal point
);

-- Insert sample data into hotel_ratings table
INSERT INTO hotel_ratings (hotel, year, rating) VALUES
	('Radisson Blu', 2020, 4.8),
	('Radisson Blu', 2021, 3.5),
	('Radisson Blu', 2022, 3.2),
	('Radisson Blu', 2023, 3.8),
	('InterContinental', 2020, 4.2),
	('InterContinental', 2021, 4.5),
	('InterContinental', 2022, 1.5),
	('InterContinental', 2023, 3.8);

-- Select all data from hotel_ratings table
SELECT * FROM hotel_ratings;

-- ######################### Solution_1 - PostgreSQL  ##########################
-- Solution Name: Remove Outliers using CTEs
-- Description: This solution uses Common Table Expressions (CTEs) to calculate the average rating for each hotel and then ranks the ratings based on their deviation from the average.
-- Key Components:
--   - AvgRatings CTE: Calculates the average rating for each hotel.
--   - RankedRatings CTE: Ranks the ratings based on their deviation from the average.
--   - Final SELECT: Filters out the top-ranked rating deviation for each hotel.
-- Notes: This solution is easy to understand and maintain due to the use of CTEs.

WITH AvgRatings AS (
	SELECT 
		hotel, 
		year, 
		rating, 
		ROUND(AVG(rating) OVER(PARTITION BY hotel ORDER BY year RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 2) AS avg_rating
	FROM 
		hotel_ratings
),
RankedRatings AS (
	SELECT 
		hotel, 
		year, 
		rating, 
		avg_rating, 
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
	year;

-- #############################################################################

-- ######################### Solution_2 - PostgreSQL  ##########################
-- Solution Name: Remove Outliers using Subqueries
-- Description: This solution uses nested subqueries to achieve the same result as Solution 1. It calculates the average rating for each hotel and ranks the ratings based on their deviation from the average.
-- Key Components:
--   - Inner Subquery (AvgRatings): Calculates the average rating for each hotel.
--   - Outer Subquery (RankedRatings): Ranks the ratings based on their deviation from the average.
--   - Final SELECT: Filters out the top-ranked rating deviation for each hotel.
-- Notes: This solution is more compact but can be harder to read and maintain compared to Solution 1.

SELECT 
	hotel, 
	year, 
	rating
FROM (
	SELECT 
		hotel, 
		year, 
		rating,
		avg_rating,
		ABS(avg_rating - rating) AS rating_diff,
		RANK() OVER(PARTITION BY hotel ORDER BY ABS(avg_rating - rating) DESC) AS rating_deviation_rank
	FROM (
		SELECT 
			hotel, 
			year, 
			rating,
			ROUND(AVG(rating) OVER(
				PARTITION BY hotel ORDER BY year RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
			), 2) AS avg_rating
		FROM 
			hotel_ratings
	) AS AvgRatings
) AS RankedRatings
WHERE 
	rating_deviation_rank > 1
ORDER BY 
	hotel, 
	year;

-- #############################################################################