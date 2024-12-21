-- PROBLEM STATEMENT: 
-- The column 'perc_viewed' in the table 'post_views' denotes the percentage of the session 
-- duration time the user spent viewing a post. Using it, calculate the total time that each 
-- post was viewed by users. Output post ID and the total viewing time in seconds, but only 
-- for posts with a total viewing time of over 5 seconds.

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Create user_sessions table if it doesn't exist
CREATE TABLE IF NOT EXISTS user_sessions (
    session_id INTEGER,
    user_id VARCHAR(10),
    session_starttime TIMESTAMP,
    session_endtime TIMESTAMP,
    platform VARCHAR(20)
);

-- Insert sample data into user_sessions table
INSERT INTO user_sessions VALUES
(1, 'U1', '2020-01-01 12:14:28', '2020-01-01 12:16:08', 'Windows'),
(2, 'U1', '2020-01-01 18:23:50', '2020-01-01 18:24:00', 'Windows'),
(3, 'U1', '2020-01-01 08:15:00', '2020-01-01 08:20:00', 'IPhone'),
(4, 'U2', '2020-01-01 10:53:10', '2020-01-01 10:53:30', 'IPhone'),
(5, 'U2', '2020-01-01 18:25:14', '2020-01-01 18:27:53', 'IPhone'),
(6, 'U2', '2020-01-01 11:28:13', '2020-01-01 11:31:33', 'Windows'),
(7, 'U3', '2020-01-01 06:46:20', '2020-01-01 06:58:13', 'Android'),
(8, 'U3', '2020-01-01 10:53:10', '2020-01-01 10:53:50', 'Android'),
(9, 'U3', '2020-01-01 13:13:13', '2020-01-01 13:34:34', 'Windows'),
(10, 'U4', '2020-01-01 08:12:00', '2020-01-01 12:23:11', 'Windows'),
(11, 'U4', '2020-01-01 21:54:03', '2020-01-01 21:54:04', 'IPad');

-- Create post_views table if it doesn't exist
CREATE TABLE IF NOT EXISTS post_views (
    session_id INTEGER,
    post_id INTEGER,
    perc_viewed FLOAT
);

-- Insert sample data into post_views table
INSERT INTO post_views VALUES
(1, 1, 2),
(1, 2, 4),
(1, 3, 1),
(2, 1, 20),
(2, 2, 10),
(2, 3, 10),
(2, 4, 21),
(3, 2, 1),
(3, 4, 1),
(4, 2, 50),
(4, 3, 10),
(6, 2, 2),
(8, 2, 5),
(8, 3, 2.5);

-- Display all records from user_sessions table
SELECT * FROM user_sessions;

-- Display all records from post_views table
SELECT * FROM post_views;

-- ######################### Solution_1 - PostgreSQL  ##########################

-- Solution Name: Calculate Total Viewing Time for Posts (Using CTE)
-- Description: This query calculates the total time each post was viewed by users based on the percentage of the session duration time spent viewing the post. It outputs the post ID and the total viewing time in seconds for posts with a total viewing time of over 5 seconds.
-- Key Components:
--   - WITH clause to create a common table expression (CTE) for session post views
--   - EXTRACT function to calculate the total session duration in seconds
--   - SUM and ROUND functions to calculate and format the total viewing time
--   - HAVING clause to filter posts with a total viewing time of over 5 seconds
-- Notes: This solution uses PostgreSQL syntax and functions.

WITH session_post_views AS (
    SELECT 
        pv.*,
        EXTRACT('EPOCH' FROM (session_endtime - session_starttime)) AS total_seconds
    FROM 
        user_sessions us
    JOIN 
        post_views pv 
    ON 
        pv.session_id = us.session_id
)
SELECT 
    post_id,
    SUM(ROUND(CAST((perc_viewed / 100) * total_seconds AS DECIMAL), 1)) AS total_viewtime
FROM 
    session_post_views
GROUP BY 
    post_id
HAVING 
    SUM(ROUND(CAST((perc_viewed / 100) * total_seconds AS DECIMAL), 1)) > 5;

-- #############################################################################

-- ######################### Solution_2 - PostgreSQL  ##########################

-- Solution Name: Calculate Total Viewing Time for Posts (Direct Join)
-- Description: This query calculates the total time each post was viewed by users based on the percentage of the session duration time spent viewing the post. It outputs the post ID and the total viewing time in seconds for posts with a total viewing time of over 5 seconds.
-- Key Components:
--   - Direct join between user_sessions and post_views tables
--   - EXTRACT function to calculate the total session duration in seconds
--   - SUM and ROUND functions to calculate and format the total viewing time
--   - HAVING clause to filter posts with a total viewing time of over 5 seconds
-- Notes: This solution uses PostgreSQL syntax and functions.

SELECT 
    post_id,
    SUM(ROUND(CAST((perc_viewed / 100) * 
        EXTRACT('EPOCH' FROM (us.session_endtime - us.session_starttime)) 
    AS DECIMAL), 1)) AS total_viewtime
FROM 
    post_views pv
JOIN 
    user_sessions us ON pv.session_id = us.session_id
GROUP BY 
    post_id
HAVING 
    SUM(ROUND(CAST((perc_viewed / 100) * 
        EXTRACT('EPOCH' FROM (us.session_endtime - us.session_starttime)) 
    AS DECIMAL), 1)) > 5;

-- #############################################################################