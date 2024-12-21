-- PROBLEM STATEMENT: 
-- A ski resort company is planning to construct a new ski slope using a pre-existing network of 
-- mountain huts and trails between them. A new slope has to begin at one of the mountain huts, 
-- have a middle station at another hut connected with the first one by a direct trail,  and end at 
-- the third mountain hut which is also connected by a direct trail to the second hut. The altitude 
-- of the three huts chosen for constructing the ski slope has to be strictly decreasing. 								
-- Assume that: 
--   there is no trail going from a hut back to itself; 
--   for every  two huts there is at most one direct trail connecting them; 
--   each hut from table trails occurs in table mountain_huts

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Create table for mountain huts
CREATE TABLE IF NOT EXISTS mountain_huts (
    id INTEGER NOT NULL,
    name VARCHAR(40) NOT NULL,
    altitude INTEGER NOT NULL,
    UNIQUE(name),
    UNIQUE(id)
);

-- Create table for trails between huts
CREATE TABLE IF NOT EXISTS trails (
    hut1 INTEGER NOT NULL,
    hut2 INTEGER NOT NULL
);

-- Insert data into mountain_huts table
INSERT INTO mountain_huts (id, name, altitude) VALUES 
(1, 'Dakonat', 1900),
(2, 'Natisa', 2100),
(3, 'Gajantut', 1600),
(4, 'Rifat', 782),
(5, 'Tupur', 1370);

-- Insert data into trails table
INSERT INTO trails (hut1, hut2) VALUES 
(1, 3),
(3, 2),
(3, 5),
(4, 5),
(1, 5);

-- Display the data in the tables
SELECT * FROM mountain_huts;
SELECT * FROM trails;

-- ######################### Solution_1 - PostgreSQL  ##########################
-- Solution Name: Find Trail Paths with Altitude Comparison
-- Description: This solution identifies the trail paths between mountain huts, ensuring that the start point is always at a higher altitude than the end point.
-- Key Components:
-- 1. start_end_pairs: Joins the mountain_huts and trails tables to get the start and end points of each trail.
-- 2. ordered_pairs: Ensures that the start point is always at a higher altitude than the end point.
-- 3. Final SELECT: Joins the ordered pairs to find the complete trail paths.
-- Notes: This solution assumes that each trail has a unique start and end point.

WITH start_end_pairs AS (
    SELECT 
        t1.hut1 AS start_hut,
        h1.name AS start_hut_name,
        h1.altitude AS start_hut_altitude,
        t1.hut2 AS end_hut,
        h2.name AS end_hut_name,
        h2.altitude AS end_hut_altitude
    FROM 
        mountain_huts h1
    JOIN 
        trails t1 ON t1.hut1 = h1.id
    JOIN 
        mountain_huts h2 ON t1.hut2 = h2.id
),
ordered_pairs AS (
    SELECT 
        CASE WHEN start_hut_altitude > end_hut_altitude THEN start_hut ELSE end_hut END AS start_hut,
        CASE WHEN start_hut_altitude > end_hut_altitude THEN start_hut_name ELSE end_hut_name END AS start_hut_name,
        CASE WHEN start_hut_altitude > end_hut_altitude THEN end_hut ELSE start_hut END AS end_hut,
        CASE WHEN start_hut_altitude > end_hut_altitude THEN end_hut_name ELSE start_hut_name END AS end_hut_name
    FROM 
        start_end_pairs
)
SELECT 
    c1.start_hut_name AS startpt,
    c1.end_hut_name AS middlept,
    c2.end_hut_name AS endpt
FROM 
    ordered_pairs c1
JOIN 
    ordered_pairs c2 ON c1.end_hut = c2.start_hut;

-- #############################################################################

-- ######################### Solution_2 - PostgreSQL  ##########################
-- Solution Name: Find Trail Paths with Altitude Flag
-- Description: This solution identifies the trail paths between mountain huts using an altitude flag to determine the start and end points.
-- Key Components:
-- 1. start_end_pairs: Joins the mountain_huts and trails tables to get the start and end points of each trail.
-- 2. paired_with_altitude_flag: Adds an altitude flag to indicate if the start point is at a higher altitude than the end point.
-- 3. valid_start_end_pairs: Uses the altitude flag to ensure the start point is always at a higher altitude than the end point.
-- 4. Final SELECT: Joins the valid start and end pairs to find the complete trail paths.
-- Notes: This solution uses an altitude flag to determine the start and end points.

WITH start_end_pairs AS (
    SELECT 
        t1.hut1 AS start_hut,
        h1.name AS start_hut_name,
        h1.altitude AS start_hut_altitude,
        t1.hut2 AS end_hut
    FROM 
        mountain_huts h1
    JOIN 
        trails t1 ON t1.hut1 = h1.id
),
paired_with_altitude_flag AS (
    SELECT 
        t2.*, 
        h2.name AS end_hut_name, 
        h2.altitude AS end_hut_altitude,
        CASE WHEN start_hut_altitude > h2.altitude THEN 1 ELSE 0 END AS altitude_flag
    FROM 
        start_end_pairs t2
    JOIN 
        mountain_huts h2 ON h2.id = t2.end_hut
),
valid_start_end_pairs AS (
    SELECT 
        CASE WHEN altitude_flag = 1 THEN start_hut ELSE end_hut END AS start_hut,
        CASE WHEN altitude_flag = 1 THEN start_hut_name ELSE end_hut_name END AS start_hut_name,
        CASE WHEN altitude_flag = 1 THEN end_hut ELSE start_hut END AS end_hut,
        CASE WHEN altitude_flag = 1 THEN end_hut_name ELSE start_hut_name END AS end_hut_name
    FROM 
        paired_with_altitude_flag
)
SELECT 
    c1.start_hut_name AS startpt,
    c1.end_hut_name AS middlept,
    c2.end_hut_name AS endpt
FROM 
    valid_start_end_pairs c1
JOIN 
    valid_start_end_pairs c2 ON c1.end_hut = c2.start_hut;

-- ############################################################################