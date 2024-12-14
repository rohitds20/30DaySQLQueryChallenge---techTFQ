CREATE DATABASE 30daychallenge;

USE 30daychallenge;

CREATE TABLE IF NOT EXISTS user_login (
    user_id INT,
    login_date DATE
);

INSERT INTO user_login (user_id, login_date) VALUES
(1, STR_TO_DATE('01/03/2024','%d/%m/%Y')),
(1, STR_TO_DATE('02/03/2024','%d/%m/%Y')),
(1, STR_TO_DATE('03/03/2024','%d/%m/%Y')),
(1, STR_TO_DATE('04/03/2024','%d/%m/%Y')),
(1, STR_TO_DATE('06/03/2024','%d/%m/%Y')),
(1, STR_TO_DATE('10/03/2024','%d/%m/%Y')),
(1, STR_TO_DATE('11/03/2024','%d/%m/%Y')),
(1, STR_TO_DATE('12/03/2024','%d/%m/%Y')),
(1, STR_TO_DATE('13/03/2024','%d/%m/%Y')),
(1, STR_TO_DATE('14/03/2024','%d/%m/%Y')),
(1, STR_TO_DATE('20/03/2024','%d/%m/%Y')),
(1, STR_TO_DATE('25/03/2024','%d/%m/%Y')),
(1, STR_TO_DATE('26/03/2024','%d/%m/%Y')),
(1, STR_TO_DATE('27/03/2024','%d/%m/%Y')),
(1, STR_TO_DATE('28/03/2024','%d/%m/%Y')),
(1, STR_TO_DATE('29/03/2024','%d/%m/%Y')),
(1, STR_TO_DATE('30/03/2024','%d/%m/%Y')),
(2, STR_TO_DATE('01/03/2024','%d/%m/%Y')),
(2, STR_TO_DATE('02/03/2024','%d/%m/%Y')),
(2, STR_TO_DATE('03/03/2024','%d/%m/%Y')),
(2, STR_TO_DATE('04/03/2024','%d/%m/%Y')),
(3, STR_TO_DATE('01/03/2024','%d/%m/%Y')),
(3, STR_TO_DATE('02/03/2024','%d/%m/%Y')),
(3, STR_TO_DATE('03/03/2024','%d/%m/%Y')),
(3, STR_TO_DATE('04/03/2024','%d/%m/%Y')),
(3, STR_TO_DATE('04/03/2024','%d/%m/%Y')),
(3, STR_TO_DATE('04/03/2024','%d/%m/%Y')),
(3, STR_TO_DATE('05/03/2024','%d/%m/%Y')),
(4, STR_TO_DATE('01/03/2024','%d/%m/%Y')),
(4, STR_TO_DATE('02/03/2024','%d/%m/%Y')),
(4, STR_TO_DATE('03/03/2024','%d/%m/%Y')),
(4, STR_TO_DATE('04/03/2024','%d/%m/%Y')),
(4, STR_TO_DATE('04/03/2024','%d/%m/%Y'));

SELECT * FROM user_login;

##################### Solution - MYSQL  ##########################

WITH login_groups AS (
    SELECT
        user_id,
        login_date,
        login_date - INTERVAL (
            DENSE_RANK() OVER (
                PARTITION BY user_id
                ORDER BY login_date
            ) - 1
        ) DAY AS date_group
    FROM user_login
)
SELECT
    user_id,
    MIN(login_date) AS start_date,
    MAX(login_date) AS end_date,
    DATEDIFF(MAX(login_date), MIN(login_date)) + 1 AS consecutive_days
FROM login_groups
GROUP BY user_id, date_group
HAVING COUNT(*) >= 5
   AND DATEDIFF(MAX(login_date), MIN(login_date)) >= 4
ORDER BY user_id, date_group;
