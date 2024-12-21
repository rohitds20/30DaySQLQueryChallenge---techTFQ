-- Problem Statement:					
-- You are given a table having the marks of one student in every test. 
-- You have to output the tests in which the student has improved his performance. 
-- For a student to improve his performance he has to score more than the previous test.
-- Provide 2 solutions, one including the first test score and second excluding it.

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Create table if it doesn't exist
CREATE TABLE IF NOT EXISTS student_tests (
    test_id INT,
    marks   INT
);

-- Insert sample data into student_tests table
INSERT INTO student_tests (test_id, marks) VALUES 
    (100, 55),
    (101, 55),
    (102, 60),
    (103, 58),
    (104, 40),
    (105, 50);

-- Select all records from student_tests table
SELECT * FROM student_tests;

-- ######################### Solution_1 - PostgreSQL  ##########################

-- Solution Name: Improved Performance Including First Test
-- Description: This query outputs the tests in which the student has improved his performance, including the first test.
-- Key Components:
--   - Subquery to get the first test
--   - Comparison with the previous test's marks
-- Notes: The first test is always included in the result.

SELECT Test_ID, Marks
FROM student_tests
WHERE Test_ID = (SELECT MIN(Test_ID) FROM student_tests)  -- Include the first test
    OR Marks > (
         SELECT Marks
         FROM student_tests AS sp
         WHERE sp.Test_ID = student_tests.Test_ID - 1       -- Check if current test score is higher than the previous one
    );

-- Solution Name: Improved Performance Excluding First Test
-- Description: This query outputs the tests in which the student has improved his performance, excluding the first test.
-- Key Components:
--   - Subquery to get the first test
--   - Comparison with the previous test's marks
-- Notes: The first test is excluded from the result.

SELECT Test_ID, Marks
FROM student_tests AS sp
WHERE Test_ID > (SELECT MIN(Test_ID) FROM student_tests)  -- Exclude the first test
    AND Marks > (
         SELECT Marks
         FROM student_tests AS sp2
         WHERE sp2.Test_ID = sp.Test_ID - 1                 -- Check if current test score is higher than the previous one
    );

-- #############################################################################

-- ######################### Solution_2 - PostgreSQL  ##########################

-- Solution Name: Improved Performance Using LAG Function
-- Description: This query outputs the tests in which the student has improved his performance using the LAG window function.
-- Key Components:
--   - LAG function to get the previous test's marks
--   - Comparison with the previous test's marks
-- Notes: The first test is excluded from the result.

SELECT *
FROM (
     SELECT *,
              LAG(marks, 1, 0) OVER(ORDER BY test_id) AS prev_test_mark  -- Get previous test's marks, default to 0 for the first test
     FROM student_tests
) AS x
WHERE x.marks > prev_test_mark;  -- Select only the records where the current test marks are greater than the previous test marks

-- Solution Name: Improved Performance Using LAG Function Including First Test
-- Description: This query outputs the tests in which the student has improved his performance using the LAG window function, including the first test.
-- Key Components:
--   - LAG function to get the previous test's marks
--   - Comparison with the previous test's marks
-- Notes: The first test is always included in the result.

SELECT *
FROM (
     SELECT *,
              LAG(marks, 1, marks) OVER(ORDER BY test_id) AS prev_test_mark  -- Get previous test's marks, default to the current marks for the first test
     FROM student_tests
) AS x
WHERE x.marks > prev_test_mark;  -- Select only the records where the current test marks are greater than the previous test marks

-- #############################################################################

-- ######################### Solution_3 - PostgreSQL  ##########################
-- Solution Name: Improved Test Scores
-- Description: This solution identifies the first test taken by students and any subsequent tests where the student's score improved compared to the previous test.
-- Key Components:
-- 1. FirstTest CTE: Selects the first test taken by students.
-- 2. ImprovedTests CTE: Identifies tests where the student's score improved compared to the previous test.
-- 3. Final Query: Combines the first test and the improved tests, ordering them by Test_ID.
-- Notes: 
-- - The first query includes the first test and all improved tests.
-- - The second query excludes the first test and only includes improved tests.
-- - The queries assume that Test_IDs are sequential and increment by 1.

-- Improved Test Scores Including First Test
WITH FirstTest AS (
    SELECT Test_ID, Marks
    FROM student_tests
    WHERE Test_ID = (SELECT MIN(Test_ID) FROM student_tests)
),
ImprovedTests AS (
    SELECT Test_ID, Marks
    FROM student_tests
    WHERE Test_ID > (SELECT MIN(Test_ID) FROM student_tests)
    AND Marks > (
        SELECT Marks
        FROM student_tests AS sp
        WHERE sp.Test_ID = student_tests.Test_ID - 1
    )
)
SELECT * FROM FirstTest
UNION ALL
SELECT * FROM ImprovedTests
ORDER BY Test_ID;

-- Improved Test Scores Excluding First Test
WITH ImprovedTests AS (
    SELECT Test_ID, Marks
    FROM student_tests
    WHERE Test_ID > (SELECT MIN(Test_ID) FROM student_tests)
    AND Marks > (
        SELECT Marks
        FROM student_tests AS sp
        WHERE sp.Test_ID = student_tests.Test_ID - 1
    )
)
SELECT * FROM ImprovedTests
ORDER BY Test_ID;

-- #############################################################################