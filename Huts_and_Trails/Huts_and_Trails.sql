CREATE 30daychallenge;

USE 30daychallenge;

CREATE TABLE IF NOT EXISTS 30daychallenge.mountain_huts (
    id INTEGER NOT NULL,
    name VARCHAR(40) NOT NULL,
    altitude INTEGER NOT NULL,
    UNIQUE(name),
    UNIQUE(id)
);

CREATE TABLE IF NOT EXISTS 30daychallenge.trails (
    hut1 INTEGER NOT NULL,
    hut2 INTEGER NOT NULL
);

INSERT INTO 30daychallenge.mountain_huts (id, name, altitude) VALUES 
(1, 'Dakonat', 1900),
(2, 'Natisa', 2100),
(3, 'Gajantut', 1600),
(4, 'Rifat', 782),
(5, 'Tupur', 1370);

INSERT INTO 30daychallenge.trails (hut1, hut2) VALUES 
(1, 3),
(3, 2),
(3, 5),
(4, 5),
(1, 5);

##################### Solution - MYSQL  ##########################

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


-- WITH start_end_pairs AS (
--     SELECT 
--         t1.hut1 AS start_hut,
--         h1.name AS start_hut_name,
--         h1.altitude AS start_hut_altitude,
--         t1.hut2 AS end_hut
--     FROM 
--         mountain_huts h1
--     JOIN 
--         trails t1 ON t1.hut1 = h1.id
-- ),
-- paired_with_altitude_flag AS (
--     SELECT 
--         t2.*, 
--         h2.name AS end_hut_name, 
--         h2.altitude AS end_hut_altitude,
--         CASE WHEN start_hut_altitude > h2.altitude THEN 1 ELSE 0 END AS altitude_flag
--     FROM 
--         start_end_pairs t2
--     JOIN 
--         mountain_huts h2 ON h2.id = t2.end_hut
-- ),
-- valid_start_end_pairs AS (
--     SELECT 
--         CASE WHEN altitude_flag = 1 THEN start_hut ELSE end_hut END AS start_hut,
--         CASE WHEN altitude_flag = 1 THEN start_hut_name ELSE end_hut_name END AS start_hut_name,
--         CASE WHEN altitude_flag = 1 THEN end_hut ELSE start_hut END AS end_hut,
--         CASE WHEN altitude_flag = 1 THEN end_hut_name ELSE start_hut_name END AS end_hut_name
--     FROM 
--         paired_with_altitude_flag
-- )
-- SELECT 
--     c1.start_hut_name AS startpt,
--     c1.end_hut_name AS middlept,
--     c2.end_hut_name AS endpt
-- FROM 
--     valid_start_end_pairs c1
-- JOIN 
--     valid_start_end_pairs c2 ON c1.end_hut = c2.start_hut;