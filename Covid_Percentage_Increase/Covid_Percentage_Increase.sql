CREATE DATABASE 30daychallenge;

USE 30daychallenge;

CREATE TABLE IF NOT EXISTS covid_cases (
    cases_reported INT,
    dates DATE
);

INSERT INTO covid_cases (cases_reported, dates) VALUES
(20124, STR_TO_DATE('10/01/2020','%d/%m/%Y')),
(40133, STR_TO_DATE('15/01/2020','%d/%m/%Y')),
(65005, STR_TO_DATE('20/01/2020','%d/%m/%Y')),
(30005, STR_TO_DATE('08/02/2020','%d/%m/%Y')),
(35015, STR_TO_DATE('19/02/2020','%d/%m/%Y')),
(15015, STR_TO_DATE('03/03/2020','%d/%m/%Y')),
(35035, STR_TO_DATE('10/03/2020','%d/%m/%Y')),
(49099, STR_TO_DATE('14/03/2020','%d/%m/%Y')),
(84045, STR_TO_DATE('20/03/2020','%d/%m/%Y')),
(100106, STR_TO_DATE('31/03/2020','%d/%m/%Y')),
(17015, STR_TO_DATE('04/04/2020','%d/%m/%Y')),
(36035, STR_TO_DATE('11/04/2020','%d/%m/%Y')),
(50099, STR_TO_DATE('13/04/2020','%d/%m/%Y')),
(87045, STR_TO_DATE('22/04/2020','%d/%m/%Y')),
(101101, STR_TO_DATE('30/04/2020','%d/%m/%Y')),
(40015, STR_TO_DATE('01/05/2020','%d/%m/%Y')),
(54035, STR_TO_DATE('09/05/2020','%d/%m/%Y')),
(71099, STR_TO_DATE('14/05/2020','%d/%m/%Y')),
(82045, STR_TO_DATE('21/05/2020','%d/%m/%Y')),
(90103, STR_TO_DATE('25/05/2020','%d/%m/%Y')),
(99103, STR_TO_DATE('31/05/2020','%d/%m/%Y')),
(11015, STR_TO_DATE('03/06/2020','%d/%m/%Y')),
(28035, STR_TO_DATE('10/06/2020','%d/%m/%Y')),
(38099, STR_TO_DATE('14/06/2020','%d/%m/%Y')),
(45045, STR_TO_DATE('20/06/2020','%d/%m/%Y')),
(36033, STR_TO_DATE('09/07/2020','%d/%m/%Y')),
(40011, STR_TO_DATE('23/07/2020','%d/%m/%Y')),
(25001, STR_TO_DATE('12/08/2020','%d/%m/%Y')),
(29990, STR_TO_DATE('26/08/2020','%d/%m/%Y')),
(20112, STR_TO_DATE('04/09/2020','%d/%m/%Y')),
(43991, STR_TO_DATE('18/09/2020','%d/%m/%Y')),
(51002, STR_TO_DATE('29/09/2020','%d/%m/%Y')),
(26587, STR_TO_DATE('25/10/2020','%d/%m/%Y')),
(11000, STR_TO_DATE('07/11/2020','%d/%m/%Y')),
(35002, STR_TO_DATE('16/11/2020','%d/%m/%Y')),
(56010, STR_TO_DATE('28/11/2020','%d/%m/%Y')),
(15099, STR_TO_DATE('02/12/2020','%d/%m/%Y')),
(38042, STR_TO_DATE('11/12/2020','%d/%m/%Y')),
(73030, STR_TO_DATE('26/12/2020','%d/%m/%Y'));

SELECT * FROM covid_cases;

##################### Solution - MYSQL  ##########################

WITH monthly_cases_cte AS (
	SELECT 
		MONTH(dates) AS month,
		SUM(cases_reported) AS monthly_cases
	FROM 
		covid_cases
	GROUP BY 
		MONTH(dates)
),
cumulative_cases_cte AS (
	SELECT 
		*,
		SUM(monthly_cases) OVER (ORDER BY month) AS total_cases
	FROM 
		monthly_cases_cte
)
SELECT 
	month,
	CASE 
		WHEN month > 1 THEN CAST(ROUND((monthly_cases / LAG(total_cases) OVER (ORDER BY month)) * 100, 1) AS CHAR)
		ELSE '-' 
	END AS percentage_increase
FROM 
	cumulative_cases_cte;