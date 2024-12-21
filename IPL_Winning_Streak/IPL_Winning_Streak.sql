/* 
PROBLEM STATEMENT: IPL Winning Streak
Given table has details of every IPL 2023 matches. Identify the maximum winning streak for each team. 
Additional test cases: 
1) Update the dataset such that when Chennai Super Kings win match no 17, your query shows the updated streak.
2) Update the dataset such that Royal Challengers Bangalore loose all match and your query should populate the winning streak as 0
*/

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

DROP TABLE IF EXISTS ipl_results;

-- Create a new table named 'ipl_results' if it doesn't exist already
CREATE TABLE IF NOT EXISTS ipl_results (
    match_no        INTEGER,
    round_number    VARCHAR(50),
    match_date      DATE,
    location        VARCHAR(50),
    home_team       VARCHAR(50),
    away_team       VARCHAR(50),
    result          VARCHAR(50)
);

-- Insert rows into the 'ipl_results' table
INSERT INTO ipl_results (match_no, round_number, match_date, location, home_team, away_team, result) VALUES 
(1, '1', '2023-03-31', 'Narendra Modi Stadium, Ahmedabad', 'Gujarat Titans', 'Chennai Super Kings', 'Gujarat Titans'),
(2, '1', '2023-04-01', 'Punjab Cricket Association IS Bindra Stadium, Moha', 'Punjab Kings', 'Kolkata Knight Riders', 'Punjab Kings'),
(3, '1', '2023-04-01', 'Bharat Ratna Shri Atal Bihari Vajpayee Ekana Crick', 'Lucknow Super Giants', 'Delhi Capitals', 'Lucknow Super Giants'),
(4, '1', '2023-04-02', 'Rajiv Gandhi International Stadium, Hyderabad', 'Sunrisers Hyderabad', 'Rajasthan Royals', 'Rajasthan Royals'),
(5, '1', '2023-04-02', 'M Chinnaswamy Stadium, Bengaluru', 'Royal Challengers Bangalore', 'Mumbai Indians', 'Royal Challengers Bangalore'),
(6, '1', '2023-04-03', 'MA Chidambaram Stadium, Chennai', 'Chennai Super Kings', 'Lucknow Super Giants', 'Chennai Super Kings'),
(7, '1', '2023-04-04', 'Arun Jaitley Stadium, Delhi', 'Delhi Capitals', 'Gujarat Titans', 'Gujarat Titans'),
(8, '1', '2023-04-05', 'Barsapara Cricket Stadium, Guwahati', 'Rajasthan Royals', 'Punjab Kings', 'Punjab Kings'),
(9, '1', '2023-04-06', 'Eden Gardens, Kolkata', 'Kolkata Knight Riders', 'Royal Challengers Bangalore', 'Kolkata Knight Riders'),
(10, '1', '2023-04-07', 'Bharat Ratna Shri Atal Bihari Vajpayee Ekana Crick', 'Lucknow Super Giants', 'Sunrisers Hyderabad', 'Lucknow Super Giants'),
(11, '2', '2023-04-08', 'Barsapara Cricket Stadium, Guwahati', 'Rajasthan Royals', 'Delhi Capitals', 'Rajasthan Royals'),
(12, '2', '2023-04-08', 'Wankhede Stadium, Mumbai', 'Mumbai Indians', 'Chennai Super Kings', 'Chennai Super Kings'),
(13, '2', '2023-04-09', 'Narendra Modi Stadium, Ahmedabad', 'Gujarat Titans', 'Kolkata Knight Riders', 'Kolkata Knight Riders'),
(14, '2', '2023-04-09', 'Rajiv Gandhi International Stadium, Hyderabad', 'Sunrisers Hyderabad', 'Punjab Kings', 'Sunrisers Hyderabad'),
(15, '2', '2023-04-10', 'M Chinnaswamy Stadium, Bengaluru', 'Royal Challengers Bangalore', 'Lucknow Super Giants', 'Lucknow Super Giants'),
(16, '2', '2023-04-11', 'Arun Jaitley Stadium, Delhi', 'Delhi Capitals', 'Mumbai Indians', 'Mumbai Indians'),
(17, '2', '2023-04-12', 'MA Chidambaram Stadium, Chennai', 'Chennai Super Kings', 'Rajasthan Royals', 'Rajasthan Royals'),
(18, '2', '2023-04-13', 'Punjab Cricket Association IS Bindra Stadium, Moha', 'Punjab Kings', 'Gujarat Titans', 'Gujarat Titans'),
(19, '2', '2023-04-14', 'Eden Gardens, Kolkata', 'Kolkata Knight Riders', 'Sunrisers Hyderabad', 'Sunrisers Hyderabad'),
(20, '3', '2023-04-15', 'M Chinnaswamy Stadium, Bengaluru', 'Royal Challengers Bangalore', 'Delhi Capitals', 'Royal Challengers Bangalore'),
(21, '3', '2023-04-15', 'Bharat Ratna Shri Atal Bihari Vajpayee Ekana Crick', 'Lucknow Super Giants', 'Punjab Kings', 'Punjab Kings'),
(22, '3', '2023-04-16', 'Wankhede Stadium, Mumbai', 'Mumbai Indians', 'Kolkata Knight Riders', 'Mumbai Indians'),
(23, '3', '2023-04-16', 'Narendra Modi Stadium, Ahmedabad', 'Gujarat Titans', 'Rajasthan Royals', 'Rajasthan Royals'),
(24, '3', '2023-04-17', 'M Chinnaswamy Stadium, Bengaluru', 'Royal Challengers Bangalore', 'Chennai Super Kings', 'Chennai Super Kings'),
(25, '3', '2023-04-18', 'Rajiv Gandhi International Stadium, Hyderabad', 'Sunrisers Hyderabad', 'Mumbai Indians', 'Mumbai Indians'),
(26, '3', '2023-04-19', 'Sawai Mansingh Stadium, Jaipur', 'Rajasthan Royals', 'Lucknow Super Giants', 'Lucknow Super Giants'),
(27, '3', '2023-04-20', 'Punjab Cricket Association IS Bindra Stadium, Moha', 'Punjab Kings', 'Royal Challengers Bangalore', 'Royal Challengers Bangalore'),
(28, '3', '2023-04-20', 'Arun Jaitley Stadium, Delhi', 'Delhi Capitals', 'Kolkata Knight Riders', 'Delhi Capitals'),
(29, '3', '2023-04-21', 'MA Chidambaram Stadium, Chennai', 'Chennai Super Kings', 'Sunrisers Hyderabad', 'Chennai Super Kings'),
(30, '4', '2023-04-22', 'Bharat Ratna Shri Atal Bihari Vajpayee Ekana Crick', 'Lucknow Super Giants', 'Gujarat Titans', 'Gujarat Titans'),
(31, '4', '2023-04-22', 'Wankhede Stadium, Mumbai', 'Mumbai Indians', 'Punjab Kings', 'Punjab Kings'),
(32, '4', '2023-04-23', 'M Chinnaswamy Stadium, Bengaluru', 'Royal Challengers Bangalore', 'Rajasthan Royals', 'Royal Challengers Bangalore'),
(33, '4', '2023-04-23', 'Eden Gardens, Kolkata', 'Kolkata Knight Riders', 'Chennai Super Kings', 'Chennai Super Kings'),
(34, '4', '2023-04-24', 'Rajiv Gandhi International Stadium, Hyderabad', 'Sunrisers Hyderabad', 'Delhi Capitals', 'Delhi Capitals'),
(35, '4', '2023-04-25', 'Narendra Modi Stadium, Ahmedabad', 'Gujarat Titans', 'Mumbai Indians', 'Gujarat Titans'),
(36, '4', '2023-04-26', 'M Chinnaswamy Stadium, Bengaluru', 'Royal Challengers Bangalore', 'Kolkata Knight Riders', 'Kolkata Knight Riders'),
(37, '4', '2023-04-27', 'Sawai Mansingh Stadium, Jaipur', 'Rajasthan Royals', 'Chennai Super Kings', 'Rajasthan Royals'),
(38, '4', '2023-04-28', 'Punjab Cricket Association IS Bindra Stadium, Moha', 'Punjab Kings', 'Lucknow Super Giants', 'Lucknow Super Giants'),
(39, '4', '2023-04-29', 'Eden Gardens, Kolkata', 'Kolkata Knight Riders', 'Gujarat Titans', 'Gujarat Titans'),
(40, '4', '2023-04-29', 'Arun Jaitley Stadium, Delhi', 'Delhi Capitals', 'Sunrisers Hyderabad', 'Sunrisers Hyderabad'),
(41, '5', '2023-04-30', 'MA Chidambaram Stadium, Chennai', 'Chennai Super Kings', 'Punjab Kings', 'Punjab Kings'),
(42, '5', '2023-04-30', 'Wankhede Stadium, Mumbai', 'Mumbai Indians', 'Rajasthan Royals', 'Mumbai Indians'),
(43, '5', '2023-05-01', 'Bharat Ratna Shri Atal Bihari Vajpayee Ekana Crick', 'Lucknow Super Giants', 'Royal Challengers Bangalore', 'Royal Challengers Bangalore'),
(44, '5', '2023-05-02', 'Narendra Modi Stadium, Ahmedabad', 'Gujarat Titans', 'Delhi Capitals', 'Delhi Capitals'),
(46, '5', '2023-05-03', 'Bharat Ratna Shri Atal Bihari Vajpayee Ekana Crick', 'Lucknow Super Giants', 'Chennai Super Kings', 'No Result'),
(45, '5', '2023-05-03', 'Punjab Cricket Association IS Bindra Stadium, Moha', 'Punjab Kings', 'Mumbai Indians', 'Mumbai Indians'),
(47, '5', '2023-05-04', 'Rajiv Gandhi International Stadium, Hyderabad', 'Sunrisers Hyderabad', 'Kolkata Knight Riders', 'Kolkata Knight Riders'),
(48, '5', '2023-05-05', 'Sawai Mansingh Stadium, Jaipur', 'Rajasthan Royals', 'Gujarat Titans', 'Gujarat Titans'),
(49, '5', '2023-05-06', 'MA Chidambaram Stadium, Chennai', 'Chennai Super Kings', 'Mumbai Indians', 'Chennai Super Kings'),
(50, '5', '2023-05-06', 'Arun Jaitley Stadium, Delhi', 'Delhi Capitals', 'Royal Challengers Bangalore', 'Delhi Capitals'),
(51, '6', '2023-05-07', 'Narendra Modi Stadium, Ahmedabad', 'Gujarat Titans', 'Lucknow Super Giants', 'Gujarat Titans'),
(52, '6', '2023-05-07', 'Sawai Mansingh Stadium, Jaipur', 'Rajasthan Royals', 'Sunrisers Hyderabad', 'Sunrisers Hyderabad'),
(53, '6', '2023-05-08', 'Eden Gardens, Kolkata', 'Kolkata Knight Riders', 'Punjab Kings', 'Kolkata Knight Riders'),
(54, '6', '2023-05-09', 'Wankhede Stadium, Mumbai', 'Mumbai Indians', 'Royal Challengers Bangalore', 'Mumbai Indians'),
(55, '6', '2023-05-10', 'MA Chidambaram Stadium, Chennai', 'Chennai Super Kings', 'Delhi Capitals', 'Chennai Super Kings'),
(56, '6', '2023-05-11', 'Eden Gardens, Kolkata', 'Kolkata Knight Riders', 'Rajasthan Royals', 'Rajasthan Royals'),
(57, '6', '2023-05-12', 'Wankhede Stadium, Mumbai', 'Mumbai Indians', 'Gujarat Titans', 'Mumbai Indians'),
(58, '6', '2023-05-13', 'Rajiv Gandhi International Stadium, Hyderabad', 'Sunrisers Hyderabad', 'Lucknow Super Giants', 'Lucknow Super Giants'),
(59, '6', '2023-05-13', 'Arun Jaitley Stadium, Delhi', 'Delhi Capitals', 'Punjab Kings', 'Punjab Kings'),
(60, '7', '2023-05-14', 'Sawai Mansingh Stadium, Jaipur', 'Rajasthan Royals', 'Royal Challengers Bangalore', 'Royal Challengers Bangalore'),
(61, '7', '2023-05-14', 'MA Chidambaram Stadium, Chennai', 'Chennai Super Kings', 'Kolkata Knight Riders', 'Kolkata Knight Riders'),
(62, '7', '2023-05-15', 'Narendra Modi Stadium, Ahmedabad', 'Gujarat Titans', 'Sunrisers Hyderabad', 'Gujarat Titans'),
(63, '7', '2023-05-16', 'Bharat Ratna Shri Atal Bihari Vajpayee Ekana Crick', 'Lucknow Super Giants', 'Mumbai Indians', 'Lucknow Super Giants'),
(64, '7', '2023-05-17', 'Himachal Pradesh Cricket Association Stadium, Dhar', 'Punjab Kings', 'Delhi Capitals', 'Delhi Capitals'),
(65, '7', '2023-05-18', 'Rajiv Gandhi International Stadium, Hyderabad', 'Sunrisers Hyderabad', 'Royal Challengers Bangalore', 'Royal Challengers Bangalore'),
(66, '7', '2023-05-19', 'Himachal Pradesh Cricket Association Stadium, Dhar', 'Punjab Kings', 'Rajasthan Royals', 'Rajasthan Royals'),
(67, '7', '2023-05-20', 'Arun Jaitley Stadium, Delhi', 'Delhi Capitals', 'Chennai Super Kings', 'Chennai Super Kings'),
(68, '7', '2023-05-20', 'Eden Gardens, Kolkata', 'Kolkata Knight Riders', 'Lucknow Super Giants', 'Lucknow Super Giants'),
(69, '7', '2023-05-21', 'Wankhede Stadium, Mumbai', 'Mumbai Indians', 'Sunrisers Hyderabad', 'Mumbai Indians'),
(70, '7', '2023-05-21', 'M Chinnaswamy Stadium, Bengaluru', 'Royal Challengers Bangalore', 'Gujarat Titans', 'Gujarat Titans'),
(71, 'Qualifier 1', '2023-05-23', 'MA Chidambaram Stadium, Chennai', 'Gujarat Titans', 'Chennai Super Kings', 'Chennai Super Kings'),
(72, 'Eliminator', '2023-05-24', 'MA Chidambaram Stadium, Chennai', 'Lucknow Super Giants', 'Mumbai Indians', 'Mumbai Indians'),
(73, 'Qualifier 2', '2023-05-26', 'Narendra Modi Stadium, Ahmedabad', 'Gujarat Titans', 'Mumbai Indians', 'Gujarat Titans'),
(74, 'Final', '2023-05-29', 'Narendra Modi Stadium, Ahmedabad', 'Chennai Super Kings', 'Gujarat Titans', 'Chennai Super Kings');

-- Select all data from the 'ipl_results' table
SELECT * FROM ipl_results;


-- Update dataset to test result
UPDATE ipl_results
SET result = 'Chennai Super Kings'
WHERE match_no = 17;

UPDATE ipl_results
SET result = 'Mumbai Indians'
WHERE match_no = 5;

UPDATE ipl_results
SET result = 'Delhi Capitals'
WHERE match_no = 20;

UPDATE ipl_results
SET result = 'Punjab Kings'
WHERE match_no = 27;

UPDATE ipl_results
SET result = 'Rajasthan Royals'
WHERE match_no = 32;

UPDATE ipl_results
SET result = 'Lucknow Super Giants'
WHERE match_no = 43;

UPDATE ipl_results
SET result = 'Rajasthan Royals'
WHERE match_no = 60;

UPDATE ipl_results
SET result = 'Sunrisers Hyderabad'
WHERE match_no = 65;

-- ######################### Solution_1 - PostgreSQL  ##########################
-- Solution Name: Winning Streak Calculation
-- Description: This query calculates the maximum winning streak for each team in the IPL 2023 season.
-- Key Components:
-- 1. team_list: Generates a list of all teams participating in the IPL.
-- 2. team_results: Associates each match with the respective team and assigns a row number based on match date.
-- 3. winning_streaks: Identifies matches where the team won and calculates a streak difference to group consecutive wins.
-- 4. streak_counts: Calculates the length of each winning streak for each team.
-- 5. Final Select: Retrieves the maximum winning streak for each team.
-- Notes: This solution uses window functions to efficiently calculate streaks and handle edge cases where teams have no wins.

WITH team_list AS (
    SELECT home_team AS team FROM ipl_results 
    UNION 
    SELECT away_team AS team FROM ipl_results
),
team_results AS (
    SELECT 
        r.match_date,
        t.team,
        r.result,
        ROW_NUMBER() OVER(PARTITION BY t.team ORDER BY r.match_date) AS row_num
    FROM ipl_results r
    JOIN team_list t ON r.home_team = t.team OR r.away_team = t.team
),
winning_streaks AS (
    SELECT 
        match_date,
        team,
        result,
        row_num,
        row_num - ROW_NUMBER() OVER(PARTITION BY team ORDER BY row_num) AS streak_diff
    FROM team_results
    WHERE result = team
),
streak_counts AS (
    SELECT 
        *,
        COUNT(1) OVER(PARTITION BY team, streak_diff ORDER BY row_num
                      RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS streak_length
    FROM winning_streaks
)
SELECT 
    t.team, 
    COALESCE(MAX(streak_length), 0) AS max_winning_streak
FROM team_list t
LEFT JOIN streak_counts s ON s.team = t.team
GROUP BY t.team
ORDER BY max_winning_streak DESC;

-- #############################################################################

-- ######################### Solution_2 - PostgreSQL ##########################
-- Solution Name: Alternative Winning Streak Calculation
-- Description: This query calculates the maximum winning streak for each team using a different approach that focuses on grouping consecutive wins.
-- Key Components:
-- 1. match_outcomes: Flattens the match data to create one row per team per match with win/loss indicators
-- 2. consecutive_wins: Uses running sum of losses to create unique groups of consecutive wins
-- 3. Subquery: Counts the length of each winning streak
-- 4. Final Select: Gets the maximum streak for each team
-- Notes: This solution is more concise than Solution_1 but achieves the same result using different window functions and grouping logic.

WITH match_outcomes AS (
    SELECT 
        match_date,
        home_team AS team,
        CASE WHEN home_team = result THEN 1 ELSE 0 END AS win
    FROM ipl_results
    UNION ALL
    SELECT 
        match_date,
        away_team AS team,
        CASE WHEN away_team = result THEN 1 ELSE 0 END AS win
    FROM ipl_results
),
consecutive_wins AS (
    SELECT 
        match_date,
        team,
        win,
        SUM(CASE WHEN win = 0 THEN 1 ELSE 0 END) OVER 
            (PARTITION BY team ORDER BY match_date) AS group_id
    FROM match_outcomes
)
SELECT 
    team,
    MAX(streak) AS max_winning_streak
FROM (
    SELECT 
        team,
        COUNT(*) AS streak
    FROM consecutive_wins
    WHERE win = 1
    GROUP BY team, group_id
) sub
GROUP BY team
ORDER BY max_winning_streak DESC;

-- #############################################################################