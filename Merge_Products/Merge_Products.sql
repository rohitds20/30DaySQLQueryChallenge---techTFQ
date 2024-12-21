-- PROBLEM STATEMENT: 
-- Write an sql query to merge products per customer for each day.

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Create the 'orders' table if it doesn't exist
CREATE TABLE IF NOT EXISTS orders (
	customer_id INT,
	dates DATE,
	product_id INT
);

-- Insert sample data into the 'orders' table
INSERT INTO orders (customer_id, dates, product_id) VALUES
	(1, '2024-02-18', 101),
	(1, '2024-02-18', 102),
	(1, '2024-02-19', 101),
	(1, '2024-02-19', 103),
	(2, '2024-02-18', 104),
	(2, '2024-02-18', 105),
	(2, '2024-02-19', 101),
	(2, '2024-02-19', 106);

-- Select all data from the 'orders' table
SELECT * FROM orders;

-- ######################### Solution_1 - PostgreSQL  ##########################
-- Solution Name: Merge Products using STRING_AGG
-- Description: This query merges products per customer for each day using the STRING_AGG function.
-- Key Components:
--   - STRING_AGG: Concatenates product IDs into a comma-separated string.
--   - DISTINCT: Ensures unique product IDs are considered.
--   - GROUP BY: Groups results by customer_id and dates.
-- Notes: This solution is specific to PostgreSQL and uses STRING_AGG for string aggregation.

SELECT 
	customer_id,
	dates,
	STRING_AGG(product_id::TEXT, ',' ORDER BY product_id) AS products
FROM (
	SELECT DISTINCT 
		customer_id, 
		dates, 
		product_id
	FROM 
		orders
) AS distinct_orders
GROUP BY 
	customer_id, 
	dates
ORDER BY 
	customer_id, 
	dates;

-- #############################################################################

-- ######################### Solution_2 - PostgreSQL  ##########################
-- Solution Name: Merge Products using ARRAY_AGG
-- Description: This query merges products per customer for each day using the ARRAY_AGG function.
-- Key Components:
--   - ARRAY_AGG: Aggregates product IDs into an array.
--   - DISTINCT: Ensures unique product IDs are considered.
--   - ARRAY_TO_STRING: Converts the array of product IDs into a comma-separated string.
--   - GROUP BY: Groups results by customer_id and dates.
-- Notes: This solution is specific to PostgreSQL and uses ARRAY_AGG for array aggregation.

SELECT 
	customer_id,
	dates,
	ARRAY_TO_STRING(ARRAY_AGG(DISTINCT product_id ORDER BY product_id), ',') AS products
FROM 
	orders
GROUP BY 
	customer_id, 
	dates
ORDER BY 
	customer_id, 
	dates;

-- #############################################################################