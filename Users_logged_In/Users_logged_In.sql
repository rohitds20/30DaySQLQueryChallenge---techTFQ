-- Problem Statement:					
-- User login table shows the date when each user logged in to the system. Identify the users 
-- who logged in for 5 or more consecutive days. Return the user id, start date, end date and 
-- no of consecutive days. Please remember a user can login multiple times during a day but 
-- only consider users whose consecutive logins spanned 5 days or more.

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Create the user_login table if it doesn't exist
CREATE TABLE IF NOT EXISTS user_login (
    user_id INT,
    login_date DATE
);

-- Insert sample data into the user_login table
INSERT INTO user_login (user_id, login_date) VALUES
(1, TO_DATE('01/03/2024','DD/MM/YYYY')),
(1, TO_DATE('02/03/2024','DD/MM/YYYY')),
(1, TO_DATE('03/03/2024','DD/MM/YYYY')),
(1, TO_DATE('04/03/2024','DD/MM/YYYY')),
(1, TO_DATE('06/03/2024','DD/MM/YYYY')),
(1, TO_DATE('10/03/2024','DD/MM/YYYY')),
(1, TO_DATE('11/03/2024','DD/MM/YYYY')),
(1, TO_DATE('12/03/2024','DD/MM/YYYY')),
(1, TO_DATE('13/03/2024','DD/MM/YYYY')),
(1, TO_DATE('14/03/2024','DD/MM/YYYY')),
(1, TO_DATE('20/03/2024','DD/MM/YYYY')),
(1, TO_DATE('25/03/2024','DD/MM/YYYY')),
(1, TO_DATE('26/03/2024','DD/MM/YYYY')),
(1, TO_DATE('27/03/2024','DD/MM/YYYY')),
(1, TO_DATE('28/03/2024','DD/MM/YYYY')),
(1, TO_DATE('29/03/2024','DD/MM/YYYY')),
(1, TO_DATE('30/03/2024','DD/MM/YYYY')),
(2, TO_DATE('01/03/2024','DD/MM/YYYY')),
(2, TO_DATE('02/03/2024','DD/MM/YYYY')),
(2, TO_DATE('03/03/2024','DD/MM/YYYY')),
(2, TO_DATE('04/03/2024','DD/MM/YYYY')),
(3, TO_DATE('01/03/2024','DD/MM/YYYY')),
(3, TO_DATE('02/03/2024','DD/MM/YYYY')),
(3, TO_DATE('03/03/2024','DD/MM/YYYY')),
(3, TO_DATE('04/03/2024','DD/MM/YYYY')),
(3, TO_DATE('04/03/2024','DD/MM/YYYY')),
(3, TO_DATE('04/03/2024','DD/MM/YYYY')),
(3, TO_DATE('05/03/2024','DD/MM/YYYY')),
(4, TO_DATE('01/03/2024','DD/MM/YYYY')),
(4, TO_DATE('02/03/2024','DD/MM/YYYY')),
(4, TO_DATE('03/03/2024','DD/MM/YYYY')),
(4, TO_DATE('04/03/2024','DD/MM/YYYY')),
(4, TO_DATE('04/03/2024','DD/MM/YYYY'));

-- Select all data from the user_login table
SELECT * FROM user_login;

-- ######################### Solution_1 - PostgreSQL  ##########################
-- Solution Name: Identify Users with 5 or More Consecutive Logins
-- Description: This query identifies users who have logged in for 5 or more consecutive days.
-- Key Components:
-- 1. Create schema and set search path.
-- 2. Create user_login table and insert sample data.
-- 3. Use a CTE (Common Table Expression) to group login dates into consecutive sequences.
-- 4. Select users with 5 or more consecutive login days and return user_id, start_date, end_date, and number of consecutive days.
-- Notes: The query uses DENSE_RANK() to identify consecutive login sequences and filters groups with at least 5 consecutive days.

WITH login_groups AS (
    SELECT
        user_id,
        login_date,
        login_date - INTERVAL '1 day' * (
            DENSE_RANK() OVER (
                PARTITION BY user_id
                ORDER BY login_date
            ) - 1
        ) AS date_group
    FROM user_login
)
SELECT
    user_id,
    MIN(login_date) AS start_date,
    MAX(login_date) AS end_date,
    (MAX(login_date) - MIN(login_date))::INTEGER + 1 AS consecutive_days
FROM login_groups
GROUP BY user_id, date_group
HAVING COUNT(*) >= 5
   AND (MAX(login_date) - MIN(login_date))::INTEGER >= 4
ORDER BY user_id, date_group;

-- #############################################################################