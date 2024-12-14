-- Create the database
CREATE DATABASE 30daychallenge;

-- Use the created database
USE 30daychallenge;

-- Create the salary table
CREATE TABLE IF NOT EXISTS salary (
    emp_id      INT,
    emp_name    VARCHAR(30),
    base_salary INT
);

-- Insert multiple rows into the salary table in a single statement
INSERT INTO 30daychallenge.salary (emp_id, emp_name, base_salary) VALUES 
    (1, 'Rohan', 5000),
    (2, 'Alex', 6000),
    (3, 'Maryam', 7000);

-- Create the income table
CREATE TABLE IF NOT EXISTS 30daychallenge.income (
    id          INT,
    income      VARCHAR(20),
    percentage  INT
);

-- Insert multiple rows into the income table
INSERT INTO 30daychallenge.income (id, income, percentage) VALUES 
    (1, 'Basic', 100),
    (2, 'Allowance', 4),
    (3, 'Others', 6);

-- Drop the deduction table if it exists and create it
DROP TABLE IF EXISTS deduction;
CREATE TABLE 30daychallenge.deduction (
    id          INT,
    deduction   VARCHAR(20),
    percentage  INT
);

-- Insert multiple rows into the deduction table
INSERT INTO 30daychallenge.deduction (id, deduction, percentage) VALUES 
    (1, 'Insurance', 5),
    (2, 'Health', 6),
    (3, 'House', 4);

-- Drop the emp_transaction table if it exists and create it
DROP TABLE IF EXISTS 30daychallenge.emp_transaction;
CREATE TABLE IF NOT EXISTS 30daychallenge.emp_transaction (
    emp_id      INT,
    emp_name    VARCHAR(50),
    trns_type   VARCHAR(20),
    amount      NUMERIC
);

-- Select statements to view the data from the tables
SELECT * FROM salary;
SELECT * FROM income;
SELECT * FROM deduction;
SELECT * FROM emp_transaction;


##################### Solution - MYSQL  ##########################

-- Insert into emp_transaction using a select statement
INSERT INTO emp_transaction (emp_id, emp_name, trns_type, amount)
SELECT 
    s.emp_id, 
    s.emp_name, 
    transaction_types.trns_type,
    ROUND(
        s.base_salary * (CAST(transaction_types.percentage AS DECIMAL) / 100), 
        2
    ) AS amount
FROM 
    salary s
CROSS JOIN (
    SELECT 
        income AS trns_type, 
        percentage 
    FROM 
        income
    UNION
    SELECT 
        deduction AS trns_type, 
        percentage 
    FROM 
        deduction
) AS transaction_types;


-- Select the data from the emp_transaction table

WITH EmployeeTransactionSummary AS (
    SELECT 
        t.emp_name AS Employee, 
        SUM(CASE WHEN t.trns_type = 'Basic' THEN t.amount ELSE 0 END) AS Basic,
        SUM(CASE WHEN t.trns_type = 'Allowance' THEN t.amount ELSE 0 END) AS Allowance,
        SUM(CASE WHEN t.trns_type = 'Others' THEN t.amount ELSE 0 END) AS Others,
        SUM(CASE WHEN t.trns_type = 'Insurance' THEN t.amount ELSE 0 END) AS Insurance,
        SUM(CASE WHEN t.trns_type = 'Health' THEN t.amount ELSE 0 END) AS Health,
        SUM(CASE WHEN t.trns_type = 'House' THEN t.amount ELSE 0 END) AS House
    FROM 
        emp_transaction t
    GROUP BY 
        t.emp_name
)

SELECT 
    Employee,
    Basic, 
    Allowance, 
    Others,
    (Basic + Allowance + Others) AS Gross,
    Insurance, 
    Health, 
    House,
    (Insurance + Health + House) AS Total_Deductions,
    ((Basic + Allowance + Others) - (Insurance + Health + House)) AS Net_Pay
FROM 
    EmployeeTransactionSummary;

-- SELECT 
--     Employee,
--     Basic, 
--     Allowance, 
--     Others,
--     (Basic + Allowance + Others) AS Gross,
--     Insurance, 
--     Health, 
--     House,
--     (Insurance + Health + House) AS Total_Deductions,
--     ((Basic + Allowance + Others) - (Insurance + Health + House)) AS Net_Pay
-- FROM 
--     (
--         SELECT 
--             t.emp_name AS Employee, 
--             SUM(CASE WHEN t.trns_type = 'Basic' THEN t.amount ELSE 0 END) AS Basic,
--             SUM(CASE WHEN t.trns_type = 'Allowance' THEN t.amount ELSE 0 END) AS Allowance,
--             SUM(CASE WHEN t.trns_type = 'Others' THEN t.amount ELSE 0 END) AS Others,
--             SUM(CASE WHEN t.trns_type = 'Insurance' THEN t.amount ELSE 0 END) AS Insurance,
--             SUM(CASE WHEN t.trns_type = 'Health' THEN t.amount ELSE 0 END) AS Health,
--             SUM(CASE WHEN t.trns_type = 'House' THEN t.amount ELSE 0 END) AS House
--         FROM 
--             emp_transaction t
--         GROUP BY 
--             t.emp_name
--     ) AS p;

##################### Solution - PostgreSQL  ##########################

SELECT 
    employee,
    basic, 
    allowance, 
    others,
    (basic + allowance + others) AS gross,
    insurance, 
    health, 
    house,
    (insurance + health + house) AS total_deductions,
    (basic + allowance + others) - (insurance + health + house) AS net_pay
FROM 
    crosstab(
        'SELECT emp_name, trns_type, SUM(amount) AS amount
         FROM emp_transaction
         GROUP BY emp_name, trns_type
         ORDER BY emp_name, trns_type',
        'SELECT DISTINCT trns_type FROM emp_transaction ORDER BY trns_type'
    ) AS result(
        employee VARCHAR, 
        Allowance NUMERIC, 
        basic NUMERIC, 
        health NUMERIC,
        house NUMERIC, 
        insurance NUMERIC, 
        others NUMERIC
    );

##################### Solution - MSSQL Server  ##########################

SELECT 
    Employee,
    Basic, 
    Allowance, 
    Others,
    (Basic + Allowance + Others) AS Gross,
    Insurance, 
    Health, 
    House,
    (Insurance + Health + House) AS Total_Deductions,
    ((Basic + Allowance + Others) - (Insurance + Health + House)) AS Net_Pay
FROM 
    (
        SELECT 
            t.emp_name AS Employee, 
            t.trns_type, 
            t.amount
        FROM 
            emp_transaction t
    ) AS b
PIVOT 
    (
        SUM(amount)
        FOR trns_type IN ([Allowance], [Basic], [Health], [House], [Insurance], [Others])
    ) AS p;