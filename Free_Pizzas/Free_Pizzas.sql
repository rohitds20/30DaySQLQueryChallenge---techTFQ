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

-- ######################### Solution_1 - PostgreSQL  ##########################

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
	TO_CHAR(ORDER_TIME, 'Mon-YYYY')ORDER BY
	EXTRACT(
		MONTH
		FROM
			TO_DATE(TO_CHAR(ORDER_TIME, 'Mon-YYYY'), 'Mon-YYYY')
	);

-- #############################################################################