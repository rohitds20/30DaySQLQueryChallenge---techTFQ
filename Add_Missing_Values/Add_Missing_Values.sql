-- Create the database
CREATE DATABASE 30daychallenge;

-- Use the created database
USE 30daychallenge;

CREATE TABLE job_skills
(
    row_id      INT,
    job_role    VARCHAR(20),
    skills      VARCHAR(20)
);

INSERT INTO job_skills (row_id, job_role, skills) VALUES
    (1, 'Data Engineer', 'SQL'),
    (2, NULL, 'Python'),
    (3, NULL, 'AWS'),
    (4, NULL, 'Snowflake'),
    (5, NULL, 'Apache Spark'),
    (6, 'Web Developer', 'Java'),
    (7, NULL, 'HTML'),
    (8, NULL, 'CSS'),
    (9, 'Data Scientist', 'Python'),
    (10, NULL, 'Machine Learning'),
    (11, NULL, 'Deep Learning'),
    (12, NULL, 'Tableau');

##################### Solution - MYSQL  ##########################

-- Solution 1 - Using Window function
WITH JobSegments AS (
    SELECT *,
           SUM(CASE WHEN job_role IS NULL THEN 0 ELSE 1 END) OVER (ORDER BY row_id) AS segment
    FROM job_skills
)
SELECT row_id,
       FIRST_VALUE(job_role) OVER (PARTITION BY segment ORDER BY row_id) AS job_role,
       skills
FROM JobSegments;


-- -- Solution 2 - Using Recursive CTE
-- WITH RECURSIVE RecursiveJobRoles AS (
--     -- Base case: Select the first row with a non-null job_role
--     SELECT row_id, job_role, skills
--     FROM job_skills
--     WHERE job_role IS NOT NULL
--     AND row_id = 1
    
--     UNION ALL
    
--     -- Recursive case: Propagate job_role from previous rows
--     SELECT e.row_id,
--            CASE 
--                WHEN e.job_role IS NULL THEN r.job_role  -- If job_role is NULL, take from previous row
--                ELSE e.job_role  -- Otherwise, keep the existing job_role
--            END AS job_role,
--            e.skills
--     FROM job_skills e
--     JOIN RecursiveJobRoles r ON e.row_id = r.row_id + 1
-- )
-- SELECT row_id, job_role, skills
-- FROM RecursiveJobRoles
-- ORDER BY row_id;


-- -- Solution 3 - Using Subquery and Self Join
-- SELECT 
--     j1.row_id, 
--     COALESCE(
--         j1.job_role, 
--         (
--             SELECT j2.job_role
--             FROM job_skills j2
--             WHERE j2.row_id < j1.row_id 
--               AND j2.job_role IS NOT NULL
--             ORDER BY j2.row_id DESC
--             LIMIT 1
--         )
--     ) AS job_role,
--     j1.skills
-- FROM job_skills j1
-- ORDER BY j1.row_id;