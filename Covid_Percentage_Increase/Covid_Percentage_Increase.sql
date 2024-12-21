-- PROBLEM STATEMENT:
-- Given table contains reported covid cases in 2020. Calculate the percentage increase 
-- in covid cases each month versus cumulative cases as of the prior month. Return the month number, 
-- and the percentage increase rounded to one decimal. Order the result by the month.

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Create the covid_cases table if it doesn't exist
CREATE TABLE IF NOT EXISTS covid_cases (
	cases_reported INT,
	dates DATE
);

-- Insert sample data into the covid_cases table
INSERT INTO covid_cases (cases_reported, dates) VALUES
(20124, TO_DATE('10/01/2020','DD/MM/YYYY')),
(40133, TO_DATE('15/01/2020','DD/MM/YYYY')),
(65005, TO_DATE('20/01/2020','DD/MM/YYYY')),
(30005, TO_DATE('08/02/2020','DD/MM/YYYY')),
(35015, TO_DATE('19/02/2020','DD/MM/YYYY')),
(15015, TO_DATE('03/03/2020','DD/MM/YYYY')),
(35035, TO_DATE('10/03/2020','DD/MM/YYYY')),
(49099, TO_DATE('14/03/2020','DD/MM/YYYY')),
(84045, TO_DATE('20/03/2020','DD/MM/YYYY')),
(100106, TO_DATE('31/03/2020','DD/MM/YYYY')),
(17015, TO_DATE('04/04/2020','DD/MM/YYYY')),
(36035, TO_DATE('11/04/2020','DD/MM/YYYY')),
(50099, TO_DATE('13/04/2020','DD/MM/YYYY')),
(87045, TO_DATE('22/04/2020','DD/MM/YYYY')),
(101101, TO_DATE('30/04/2020','DD/MM/YYYY')),
(40015, TO_DATE('01/05/2020','DD/MM/YYYY')),
(54035, TO_DATE('09/05/2020','DD/MM/YYYY')),
(71099, TO_DATE('14/05/2020','DD/MM/YYYY')),
(82045, TO_DATE('21/05/2020','DD/MM/YYYY')),
(90103, TO_DATE('25/05/2020','DD/MM/YYYY')),
(99103, TO_DATE('31/05/2020','DD/MM/YYYY')),
(11015, TO_DATE('03/06/2020','DD/MM/YYYY')),
(28035, TO_DATE('10/06/2020','DD/MM/YYYY')),
(38099, TO_DATE('14/06/2020','DD/MM/YYYY')),
(45045, TO_DATE('20/06/2020','DD/MM/YYYY')),
(36033, TO_DATE('09/07/2020','DD/MM/YYYY')),
(40011, TO_DATE('23/07/2020','DD/MM/YYYY')),
(25001, TO_DATE('12/08/2020','DD/MM/YYYY')),
(29990, TO_DATE('26/08/2020','DD/MM/YYYY')),
(20112, TO_DATE('04/09/2020','DD/MM/YYYY')),
(43991, TO_DATE('18/09/2020','DD/MM/YYYY')),
(51002, TO_DATE('29/09/2020','DD/MM/YYYY')),
(26587, TO_DATE('25/10/2020','DD/MM/YYYY')),
(11000, TO_DATE('07/11/2020','DD/MM/YYYY')),
(35002, TO_DATE('16/11/2020','DD/MM/YYYY')),
(56010, TO_DATE('28/11/2020','DD/MM/YYYY')),
(15099, TO_DATE('02/12/2020','DD/MM/YYYY')),
(38042, TO_DATE('11/12/2020','DD/MM/YYYY')),
(73030, TO_DATE('26/12/2020','DD/MM/YYYY'));

-- Select all data from the covid_cases table
SELECT * FROM covid_cases;

-- ######################### Solution_1 - PostgreSQL  ##########################
-- Description:
-- This solution calculates the percentage increase in covid cases each month versus cumulative cases as of the prior month.
-- It returns the month number and the percentage increase rounded to one decimal. The result is ordered by the month.

-- Key Components:
-- 1. monthly_cases CTE: Aggregates the total cases reported for each month.
-- 2. cumulative_cases CTE: Calculates the cumulative total cases up to each month.
-- 3. Final SELECT: Computes the percentage increase in cases for each month compared to the previous month's cumulative cases.

-- Notes:
-- - The percentage increase is calculated only for months after the first month.
-- - If there is no previous month's data, the percentage increase is represented as '-'.
-- - The result is rounded to one decimal place.

WITH monthly_cases AS (
	SELECT 
		EXTRACT(MONTH FROM dates) AS month,
		SUM(cases_reported) AS monthly_cases
	FROM 
		covid_cases
	GROUP BY 
		EXTRACT(MONTH FROM dates)
),
cumulative_cases AS (
	SELECT 
		*,
		SUM(monthly_cases) OVER (ORDER BY month) AS total_cases
	FROM 
		monthly_cases
)
SELECT 
	month,
	CASE 
		WHEN month > 1 THEN ROUND((monthly_cases / LAG(total_cases) OVER (ORDER BY month)) * 100, 1)::TEXT
		ELSE '-' 
	END AS percentage_increase
FROM 
	cumulative_cases;

-- #############################################################################

-- ######################### Solution_2 - PostgreSQL  ##########################

-- Description:
-- This solution calculates the percentage increase in covid cases each month versus cumulative cases as of the prior month.
-- It returns the month number and the percentage increase rounded to one decimal. The result is ordered by the month.

-- Key Components:
-- 1. monthly_cases CTE: Aggregates the total cases reported for each month.
-- 2. cumulative_cases CTE: Calculates the cumulative total cases up to each month.
-- 3. percentage_increase CTE: Computes the previous month's cumulative cases for each month.
-- 4. Final SELECT: Computes the percentage increase in cases for each month compared to the previous month's cumulative cases.

-- Notes:
-- - The percentage increase is calculated only for months after the first month.
-- - If there is no previous month's data, the percentage increase is represented as '-'.
-- - The result is rounded to one decimal place.

WITH monthly_cases AS (
	SELECT 
		EXTRACT(MONTH FROM dates) AS month,
		SUM(cases_reported) AS monthly_cases
	FROM 
		covid_cases
	GROUP BY 
		EXTRACT(MONTH FROM dates)
),
cumulative_cases AS (
	SELECT 
		month,
		monthly_cases,
		SUM(monthly_cases) OVER (ORDER BY month) AS total_cases
	FROM 
		monthly_cases
),
percentage_increase AS (
	SELECT 
		month,
		monthly_cases,
		total_cases,
		LAG(total_cases) OVER (ORDER BY month) AS previous_total_cases
	FROM 
		cumulative_cases
)
SELECT 
	month,
	CASE 
		WHEN month > 1 AND previous_total_cases IS NOT NULL 
		THEN ROUND((monthly_cases / previous_total_cases) * 100, 1)::TEXT
		ELSE '-' 
	END AS percentage_increase
FROM 
	percentage_increase;

-- #############################################################################