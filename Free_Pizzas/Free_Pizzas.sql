-- PROBLEM STATEMENT: 
-- Given table showcases details of pizza delivery order for the year of 2023.
-- If an order is delayed then the whole order is given for free. Any order that takes 30 minutes 
-- more than the order time is considered as delayed order. Identify the percentage of delayed order 
-- for each month and also display the total no of free pizzas given each month.
-- Sort the result in order of months.

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Create a table named 'pizza_delivery' if it doesn't exist
-- Table stores information about pizza orders including:
-- - order_id: unique identifier for each order
-- - order_time: when the order was placed
-- - expected_delivery: expected delivery time
-- - actual_delivery: actual time of delivery
-- - no_of_pizzas: number of pizzas in the order
-- - price: total cost of the order
CREATE TABLE IF NOT EXISTS pizza_delivery (
	order_id INTEGER,
	order_time TIMESTAMP,
	expected_delivery TIMESTAMP,
	actual_delivery TIMESTAMP,
	no_of_pizzas INTEGER,
	price DECIMAL(10,2)
);

-- Insert sample data into the pizza_delivery table
INSERT INTO pizza_delivery (order_id, order_time, expected_delivery, actual_delivery, no_of_pizzas, price)
VALUES
	(1, '2022-01-01 12:00:00', '2022-01-01 12:30:00', '2022-01-01 12:35:00', 2, 20.00),
	(2, '2022-01-02 18:00:00', '2022-01-02 18:30:00', '2022-01-02 18:40:00', 3, 30.00),
	(3, '2022-01-03 20:00:00', '2022-01-03 20:30:00', '2022-01-03 20:35:00', 1, 10.00),
	(4, '2022-01-04 14:00:00', '2022-01-04 14:30:00', '2022-01-04 14:40:00', 2, 20.00),
	(5, '2022-01-05 17:00:00', '2022-01-05 17:30:00', '2022-01-05 17:35:00', 3, 30.00);

-- Retrieve all records from the pizza_delivery table
SELECT * FROM pizza_delivery;

-- truncate the table to remove all records
TRUNCATE TABLE "30daychallenge".pizza_delivery;

-- load csv data to postgresql table using import data wizard in pgadmin
-- IMPORT/EXPORT DATA -> GENERAL -> IMPORT -> FILE NAME , FORMAT , ENCODING
-- review options and columns tabs as well and click on OK

-- Retrieve all records from the pizza_delivery table
SELECT * FROM pizza_delivery;

-- ######################### Solution_1 - PostgreSQL Using CTE and Time Extraction ##########################
/*
Solution Name: Pizza_Delivery_Analytics_Using_Time_Components

Description:
This solution analyzes pizza delivery performance and free pizza distribution by:
1. Calculating delivery delays by extracting time components
2. Computing monthly delay percentages
3. Tracking free pizzas given for delayed deliveries

Key Components:
- CTE delivery_stats:
	- Extracts month and year from order time
	- Calculates delivery duration in minutes using HOUR and MINUTE components
	- Tracks number of pizzas per order

- Main Query:
	- Groups results by month
	- Calculates delay percentage with proper formatting
	- Counts free pizzas for delayed orders
	- Orders results chronologically

Notes:
- Uses PostgreSQL time extraction functions
- Assumes 30+ minute delivery time qualifies as delayed
- Handles null delivery times by excluding them
- More precise than EPOCH calculation for time differences
*/

SET search_path TO "30daychallenge";

WITH delivery_stats AS (
	SELECT 
		TO_CHAR(ORDER_TIME, 'Mon-YYYY') AS PERIOD,
		EXTRACT(HOUR FROM (ACTUAL_DELIVERY - ORDER_TIME)) * 60 + 
		EXTRACT(MINUTE FROM (ACTUAL_DELIVERY - ORDER_TIME)) AS delivery_minutes,
		NO_OF_PIZZAS
	FROM PIZZA_DELIVERY
	WHERE ACTUAL_DELIVERY IS NOT NULL
)
SELECT 
	PERIOD,
	CONCAT(
		ROUND(
			(CAST(SUM(CASE WHEN delivery_minutes > 30 THEN 1 ELSE 0 END) AS DECIMAL) 
			/ COUNT(*)) * 100,
			1
		),
		'%'
	) AS DELAYED_FLAG,
	SUM(CASE WHEN delivery_minutes > 30 THEN NO_OF_PIZZAS ELSE 0 END) AS FREE_PIZZAS
FROM delivery_stats
GROUP BY PERIOD
ORDER BY EXTRACT(MONTH FROM TO_DATE(PERIOD, 'Mon-YYYY'));

-- #############################################################################

-- ######################### Solution_2 - PostgreSQL  ##########################
/*
Solution Name: Delivery_Performance_And_Free_Pizzas_Analysis

Description:
This query analyzes pizza delivery performance and calculates free pizzas given by month.
It focuses on:
1. Monthly delivery delays percentage
2. Number of free pizzas due to late deliveries (>30 min)

Key Components:
- CTE delivery_stats: Transforms raw delivery data into analysis-ready format
	- Extracts month-year period
	- Calculates delivery time in minutes
	- Includes number of pizzas per order

- Main Query:
	- Groups data by month
	- Calculates percentage of delayed deliveries
	- Sums up free pizzas for orders exceeding 30 minutes
	- Orders results chronologically

Notes:
- Uses PostgreSQL specific functions (TO_CHAR, EXTRACT)
- Assumes delivery time > 30 minutes qualifies for free pizza
- Formats delay percentage with % symbol
- Null delivery times are excluded from analysis
*/

SET search_path TO "30daychallenge";

WITH delivery_stats AS (
	SELECT 
		TO_CHAR(ORDER_TIME, 'Mon-YYYY') AS PERIOD,
		EXTRACT(EPOCH FROM (ACTUAL_DELIVERY - ORDER_TIME)) / 60 AS delivery_minutes,
		NO_OF_PIZZAS
	FROM PIZZA_DELIVERY
	WHERE ACTUAL_DELIVERY IS NOT NULL
)
SELECT 
	PERIOD,
	ROUND(
		(CAST(SUM(CASE WHEN delivery_minutes > 30 THEN 1 ELSE 0 END) AS DECIMAL) 
		/ COUNT(*)) * 100,
		1
	) || '%' AS DELAYED_FLAG,
	SUM(CASE WHEN delivery_minutes > 30 THEN NO_OF_PIZZAS ELSE 0 END) AS FREE_PIZZAS
FROM delivery_stats
GROUP BY PERIOD
ORDER BY TO_DATE(PERIOD, 'Mon-YYYY');

-- #############################################################################

-- ######################### Solution_3 - PostgreSQL  ##########################
/*
Solution Name: Direct_Pizza_Delivery_Analysis

Description:
This solution provides a direct, single-query approach to analyze pizza delivery performance by:
1. Calculating delivery delays without using CTEs
2. Computing percentage of delayed orders per month
3. Determining free pizzas given for delayed deliveries

Key Components:
- Direct Query Structure:
	- Period formatting using TO_CHAR
	- Inline delivery time calculation using EXTRACT
	- Conditional aggregation for delays and free pizzas
	- Month-based sorting

- Time Calculations:
	- Converts delivery time to minutes using HOUR and MINUTE extraction
	- Handles delay threshold of 30 minutes
	- Includes proper null handling

Notes:
- More compact than CTE-based solutions
- Uses PostgreSQL's EXTRACT function for precise time calculations
- May be less readable but more performant for smaller datasets
- Maintains consistent results with CTE-based approaches
*/

SET search_path TO "30daychallenge";

SELECT
	TO_CHAR(ORDER_TIME, 'Mon-YYYY') AS PERIOD,
	CONCAT(
		ROUND(
			(
				CAST(
					SUM(
						CASE
							WHEN EXTRACT(
								HOUR
								FROM
									(ACTUAL_DELIVERY - ORDER_TIME)
							) * 60 + EXTRACT(
								MINUTE
								FROM
									(ACTUAL_DELIVERY - ORDER_TIME)
							) > 30 THEN 1
							ELSE 0
						END
					) AS DECIMAL
				) / COUNT(*)
			) * 100,
			1
		),
		'%'
	) AS DELAYED_FLAG,
	SUM(
		CASE
			WHEN EXTRACT(
				HOUR
				FROM
					(ACTUAL_DELIVERY - ORDER_TIME)
			) * 60 + EXTRACT(
				MINUTE
				FROM
					(ACTUAL_DELIVERY - ORDER_TIME)
			) > 30 THEN NO_OF_PIZZAS
			ELSE 0
		END
	) AS FREE_PIZZAS
FROM
	PIZZA_DELIVERY
WHERE
	ACTUAL_DELIVERY IS NOT NULL
GROUP BY
	TO_CHAR(ORDER_TIME, 'Mon-YYYY')
ORDER BY
	EXTRACT(
		MONTH
		FROM
			TO_DATE(TO_CHAR(ORDER_TIME, 'Mon-YYYY'), 'Mon-YYYY')
	);

-- #############################################################################