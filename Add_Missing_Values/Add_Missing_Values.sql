-- PROBLEM STATEMENT: 
-- In the given input table, there are rows with missing JOB_ROLE values. Write a query 
-- to fill in those blank fields with appropriate values. Assume row_id is always in sequence 
-- and job_role field is populated only for the first skill. Provide two different solutions to the problem.						

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Creates a table named 'job_skills' if it doesn't already exist
-- Table stores information about job roles and required skills including:
-- - row_id: unique identifier for each skill entry 
-- - job_role: name of the job position/role
-- - skills: specific skill required for the job role
CREATE TABLE IF NOT EXISTS job_skills (
    row_id      INTEGER,
    job_role    VARCHAR(20),
    skills      VARCHAR(20)
);


-- Insert sample data into job_skills table with job roles and their required skills
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

-- Retrieve all records from the pizza_delivery table
SELECT * FROM job_skills;

/*
###################### Add Missing Job Role Values ######################

PROBLEM:
Fill missing job_role values with the most recent non-null value from previous rows.

SOLUTIONS:

1. Window Function Segmentation Approach
- Uses window functions to create segments of job roles
- Fills gaps using FIRST_VALUE within segments
KEY COMPONENTS:
- Window functions: SUM(), FIRST_VALUE()
- CASE statement for segment creation
NOTES: 
- Efficient for large datasets
- Good performance with partitioned data

2. Recursive CTE Forward Propagation
- Uses recursive CTE to iterate through rows
- Propagates values from previous row if current is null
KEY COMPONENTS:
- Recursive CTE
- CASE statement for value propagation
- Base case and recursive member
NOTES:
- May hit recursion limits on very large datasets
- Clear logical flow but potentially slower than window functions

3. Correlated Subquery Last Known Value
- Uses correlated subquery to find last non-null value
- Simple and straightforward approach
KEY COMPONENTS:
- Correlated subquery
- COALESCE for null handling
NOTES:
- May be slower for large datasets
- Good for small to medium-sized tables
- Easier to understand and maintain

GENERAL NOTES:
- All solutions maintain row ordering
- Compatible with PostgreSQL
- Solution choice depends on:
    * Dataset size
    * Performance requirements
    * Maintainability needs
*/
-- ######################### Solution_1 - PostgreSQL ##########################

WITH JobSegments AS (
    SELECT *,
           SUM(CASE WHEN job_role IS NULL THEN 0 ELSE 1 END) OVER (ORDER BY row_id) AS segment
    FROM job_skills
)
SELECT row_id,
       FIRST_VALUE(job_role) OVER (PARTITION BY segment ORDER BY row_id) AS job_role,
       skills
FROM JobSegments;

-- #############################################################################

-- ######################### Solution_2 - PostgreSQL  ##########################

WITH RECURSIVE RecursiveJobRoles AS (
    SELECT row_id, job_role, skills
    FROM job_skills
    WHERE job_role IS NOT NULL
    AND row_id = 1
    
    UNION ALL
    
    -- Recursive case: Propagate job_role from previous rows
    SELECT e.row_id,
           CASE 
               WHEN e.job_role IS NULL THEN r.job_role
               ELSE e.job_role
           END AS job_role,
           e.skills
    FROM job_skills e
    JOIN RecursiveJobRoles r ON e.row_id = r.row_id + 1
)
SELECT row_id, job_role, skills
FROM RecursiveJobRoles
ORDER BY row_id;

-- #############################################################################

-- ######################### Solution_3 - PostgreSQL  ##########################

SELECT j1.row_id, 
    COALESCE(j1.job_role, 
          (SELECT j2.job_role
           FROM job_skills j2
           WHERE j2.row_id < j1.row_id 
             AND j2.job_role IS NOT NULL
           ORDER BY j2.row_id DESC
           LIMIT 1)
    ) AS job_role,
    j1.skills
FROM job_skills j1
ORDER BY j1.row_id;

-- #############################################################################