CREATE DATABASE 30daychallenge;

USE 30daychallenge;

CREATE TABLE IF NOT EXISTS orders (
	customer_id INT,
	dates DATE,
	product_id INT
);

INSERT INTO orders (customer_id, dates, product_id) VALUES
	(1, '2024-02-18', 101),
	(1, '2024-02-18', 102),
	(1, '2024-02-19', 101),
	(1, '2024-02-19', 103),
	(2, '2024-02-18', 104),
	(2, '2024-02-18', 105),
	(2, '2024-02-19', 101),
	(2, '2024-02-19', 106);

SELECT * FROM orders;

##################### Solution - MYSQL  ##########################

SELECT customer_id,
       dates,
       GROUP_CONCAT(DISTINCT product_id ORDER BY product_id) AS products
FROM orders
GROUP BY customer_id, dates
ORDER BY customer_id, dates;


##################### Solution - PostgreSQL  ##########################

SELECT customer_id,
       dates,
       STRING_AGG(product_id::TEXT, ',' ORDER BY product_id) AS products
FROM (
    SELECT DISTINCT customer_id, dates, product_id
    FROM orders
) AS distinct_orders
GROUP BY customer_id, dates
ORDER BY customer_id, dates;
