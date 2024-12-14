CREATE DATABASE 30daychallenge;

USE 30daychallenge;

CREATE TABLE IF NOT EXISTS friends (
    friend1 VARCHAR(10),
    friend2 VARCHAR(10)
);

INSERT INTO friends (friend1, friend2) VALUES 
('Jason', 'Mary'),
('Mike', 'Mary'),
('Mike', 'Jason'),
('Susan', 'Jason'),
('John', 'Mary'),
('Susan', 'Mary');

SELECT * FROM friends;

##################### Solution - MYSQL  ##########################

WITH all_friends AS (
    SELECT friend1, friend2 FROM friends
    UNION 
    SELECT friend2, friend1 FROM friends
)
SELECT 
    f.friend1, 
    f.friend2,
    COUNT(cf.friend1) AS mutual_friends
FROM 
    friends f
LEFT JOIN 
    all_friends cf 
    ON f.friend1 = cf.friend1
    AND cf.friend2 IN (
        SELECT cf2.friend2
        FROM all_friends cf2
        WHERE f.friend2 = cf2.friend1
    )
GROUP BY 
    f.friend1, f.friend2
ORDER BY 
    f.friend1, f.friend2;


