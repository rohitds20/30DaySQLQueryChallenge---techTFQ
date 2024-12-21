-- PROBLEM STATEMENT:
-- In the given input table DAY_INDICATOR field indicates the day of the week with the 
-- first character being Monday, followed by Tuesday and so on. Write a query to filter 
-- the dates column to showcase only those days where day_indicator character for that day of the week is 1							

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Create the Day_Indicator table if it doesn't exist
CREATE TABLE IF NOT EXISTS Day_Indicator (
    Product_ID     VARCHAR(10),
    Day_Indicator  VARCHAR(7),
    Dates          DATE
);

-- Insert multiple rows into the Day_Indicator table
INSERT INTO Day_Indicator (Product_ID, Day_Indicator, Dates) VALUES
    ('AP755', '1010101', TO_DATE('04-Mar-2024', 'DD-Mon-YYYY')),
    ('AP755', '1010101', TO_DATE('05-Mar-2024', 'DD-Mon-YYYY')),
    ('AP755', '1010101', TO_DATE('06-Mar-2024', 'DD-Mon-YYYY')),
    ('AP755', '1010101', TO_DATE('07-Mar-2024', 'DD-Mon-YYYY')),
    ('AP755', '1010101', TO_DATE('08-Mar-2024', 'DD-Mon-YYYY')),
    ('AP755', '1010101', TO_DATE('09-Mar-2024', 'DD-Mon-YYYY')),
    ('AP755', '1010101', TO_DATE('10-Mar-2024', 'DD-Mon-YYYY')),
    ('XQ802', '1000110', TO_DATE('04-Mar-2024', 'DD-Mon-YYYY')),
    ('XQ802', '1000110', TO_DATE('05-Mar-2024', 'DD-Mon-YYYY')),
    ('XQ802', '1000110', TO_DATE('06-Mar-2024', 'DD-Mon-YYYY')),
    ('XQ802', '1000110', TO_DATE('07-Mar-2024', 'DD-Mon-YYYY')),
    ('XQ802', '1000110', TO_DATE('08-Mar-2024', 'DD-Mon-YYYY')),
    ('XQ802', '1000110', TO_DATE('09-Mar-2024', 'DD-Mon-YYYY')),
    ('XQ802', '1000110', TO_DATE('10-Mar-2024', 'DD-Mon-YYYY'));

-- Select all data from the Day_Indicator table
SELECT * FROM Day_Indicator;

-- ######################### Solution_1 - PostgreSQL ##########################
/*
Solution Name: Subquery with Flag Approach
Description: Uses a subquery to create a flag for filtering dates based on day indicator pattern
Key Components:
- EXTRACT('ISODOW') to get ISO day of week (1=Monday to 7=Sunday)
- SUBSTRING to check specific position in day_indicator
- CASE statement to create Include/Exclude flag
Notes: 
- More verbose but clearer to understand the logic
- Useful when additional flag-based processing is needed
*/

SELECT 
    product_id, 
    day_indicator, 
    dates
FROM (
    SELECT 
        *, 
        EXTRACT('ISODOW' FROM dates) AS dow,
        CASE 
            WHEN SUBSTRING(day_indicator, EXTRACT('ISODOW' FROM dates)::int, 1) = '1' 
            THEN 'Include' 
            ELSE 'Exclude' 
        END AS flag
    FROM Day_Indicator
) AS day_status
WHERE flag = 'Include';

-- ######################### Solution_2 - PostgreSQL  ##########################
/*
Solution Name: Direct Filter Approach
Description: Directly filters rows using WHERE clause without intermediate steps
Key Components:
- SUBSTRING function for pattern matching
- EXTRACT('ISODOW') for day of week
Notes: 
- More concise and performant
- Same logic as Solution 1 but without subquery
*/

SELECT 
    product_id, 
    day_indicator, 
    dates
FROM Day_Indicator
WHERE SUBSTRING(day_indicator, EXTRACT('ISODOW' FROM dates)::int, 1) = '1';

-- ######################### Solution_3 - PostgreSQL  ##########################
/*
Solution Name: Alternative Syntax Approach
Description: Same as Solution 2 but uses SUBSTR and DATE_PART instead
Key Components:
- SUBSTR function (alternative to SUBSTRING)
- DATE_PART (alternative to EXTRACT)
Notes:
- Functionally identical to Solution 2
- Shows PostgreSQL's function flexibility
*/

SELECT 
    product_id, 
    day_indicator, 
    dates
FROM Day_Indicator
WHERE SUBSTR(day_indicator, DATE_PART('ISODOW', dates)::int, 1) = '1';

-- #############################################################################
