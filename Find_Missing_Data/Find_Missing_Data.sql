-- PROBLEM STATEMENT: 
-- In the given input table, some of the invoice are missing, write a sql query to identify the missing serial no. 
-- As an assumption, consider the serial no with the lowest value to be the 
-- first generated invoice and the highest serial no value to be the last generated invoice				

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Create the invoice table if it doesn't exist
CREATE TABLE IF NOT EXISTS invoice (
    serial_no INT,
    invoice_date DATE
);

-- Insert data into the invoice table
INSERT INTO invoice (serial_no, invoice_date) VALUES 
(330115, TO_DATE('01-Mar-2024','DD-Mon-YYYY')),
(330120, TO_DATE('01-Mar-2024','DD-Mon-YYYY')),
(330121, TO_DATE('01-Mar-2024','DD-Mon-YYYY')),
(330122, TO_DATE('02-Mar-2024','DD-Mon-YYYY')),
(330125, TO_DATE('02-Mar-2024','DD-Mon-YYYY'));

-- Select all data from the invoice table
SELECT * FROM invoice;

-- ######################### Solution_1 - PostgreSQL ##########################
-- Solution Name: Recursive CTE Method
-- Description: This solution uses a recursive Common Table Expression (CTE) to generate a sequence of serial numbers from the minimum to the maximum serial number in the invoice table. It then selects the serial numbers that are not present in the invoice table.
-- Key Components:
-- 1. WITH RECURSIVE: Defines a recursive CTE named serial_numbers.
-- 2. SELECT MIN(serial_no): Initializes the CTE with the minimum serial number.
-- 3. UNION ALL: Recursively generates the next serial number by adding 1 to the current serial number.
-- 4. WHERE serial_no + 1 <= (SELECT MAX(serial_no)): Ensures the recursion stops at the maximum serial number.
-- 5. SELECT serial_no as missing_serial_numbers: Selects the serial numbers that are not present in the invoice table.
-- Notes: This method is useful for generating a sequence of numbers and finding missing values within that sequence.

WITH RECURSIVE
    serial_numbers AS (
        SELECT MIN(serial_no) AS serial_no
        FROM invoice
        UNION ALL
        SELECT serial_no + 1
        FROM serial_numbers
        WHERE
            serial_no + 1 <= (
                SELECT MAX(serial_no)
                FROM invoice
            )
    )
SELECT
    serial_no as missing_serial_numbers
FROM serial_numbers
WHERE
    serial_no NOT IN(
        SELECT serial_no
        FROM invoice
    );
    
-- #############################################################################

-- ######################### Solution_2 - PostgreSQL  ##########################
-- Solution Name: Generate Series Method
-- Description: This solution uses the generate_series function to create a sequence of serial numbers from the minimum to the maximum serial number in the invoice table. It then selects the serial numbers that are not present in the invoice table.
-- Key Components:
-- 1. generate_series(MIN(serial_no), MAX(serial_no)): Generates a sequence of serial numbers from the minimum to the maximum serial number.
-- 2. EXCEPT: Selects the serial numbers that are not present in the invoice table.
-- 3. ORDER BY 1: Orders the result by the serial number.
-- Notes: This method is straightforward and leverages PostgreSQL's built-in generate_series function to create the sequence of numbers.

SELECT generate_series(MIN(serial_no), MAX(serial_no)) AS missing_serial_no
FROM invoice
EXCEPT 
SELECT serial_no 
FROM invoice
ORDER BY 1;

-- #############################################################################