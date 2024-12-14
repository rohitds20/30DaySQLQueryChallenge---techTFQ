CREATE DATABASE 30daychallenge;

USE 30daychallenge;

CREATE TABLE IF NOT EXISTS 30daychallenge.student_tests (
    test_id INT,
    marks   INT
);

INSERT INTO 30daychallenge.student_tests (test_id, marks) VALUES 
    (100, 55),
    (101, 55),
    (102, 60),
    (103, 58),
    (104, 40),
    (105, 50);

SELECT * FROM 30daychallenge.student_tests;

##################### Solution - MYSQL  ##########################

SELECT Test_ID, Marks
FROM student_tests
WHERE Test_ID = (SELECT MIN(Test_ID) FROM student_tests)  -- Include the first test
   OR Marks > (
       SELECT Marks
       FROM student_tests AS sp
       WHERE sp.Test_ID = student_tests.Test_ID - 1       -- Check if current test score is higher than the previous one
   );

SELECT Test_ID, Marks
FROM student_tests AS sp
WHERE Test_ID > (SELECT MIN(Test_ID) FROM student_tests)  -- Exclude the first test
   AND Marks > (
       SELECT Marks
       FROM student_tests AS sp2
       WHERE sp2.Test_ID = sp.Test_ID - 1                 -- Check if current test score is higher than the previous one
   );


-- WITH FirstTest AS (
--     SELECT Test_ID, Marks
--     FROM student_tests
--     WHERE Test_ID = (SELECT MIN(Test_ID) FROM student_tests)  -- Select the first test
-- ),
-- ImprovedTests AS (
--     SELECT st.Test_ID, st.Marks
--     FROM student_tests st
--     JOIN student_tests prev ON st.Test_ID = prev.Test_ID + 1  -- Join with previous test
--     WHERE st.Marks > prev.Marks                               -- Check if score improved
-- )

-- SELECT Test_ID, Marks
-- FROM FirstTest
-- UNION ALL
-- SELECT Test_ID, Marks
-- FROM ImprovedTests
-- ORDER BY Test_ID;


-- WITH ImprovedTests AS (
--     SELECT st.Test_ID, st.Marks
--     FROM student_tests st
--     JOIN student_tests prev ON st.Test_ID = prev.Test_ID + 1  -- Join with previous test
--     WHERE st.Marks > prev.Marks                               -- Check if score improved
-- )

-- SELECT Test_ID, Marks
-- FROM ImprovedTests
-- WHERE Test_ID > (SELECT MIN(Test_ID) FROM student_tests)      -- Exclude the first test
-- ORDER BY Test_ID;


-- SELECT *
-- FROM (
--     SELECT *,
--            LAG(marks, 1, 0) OVER(ORDER BY test_id) AS prev_test_mark  -- Get previous test's marks, default to 0 for the first test
--     FROM student_tests
-- ) AS x
-- WHERE x.marks > prev_test_mark;  -- Select only the records where the current test marks are greater than the previous test marks

-- SELECT *
-- FROM (
--     SELECT *,
--            LAG(marks, 1, marks) OVER(ORDER BY test_id) AS prev_test_mark  -- Get previous test's marks, default to the current marks for the first test
--     FROM student_tests
-- ) AS x
-- WHERE x.marks > prev_test_mark;  -- Select only the records where the current test marks are greater than the previous test marks

