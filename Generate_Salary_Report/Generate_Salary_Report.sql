-- PROBLEM STATEMENT: 
-- Using the given Salary, Income and Deduction tables, first write an sql query 
-- to populate the Emp_Transaction table and then generate a salary report.										

-- Create a new schema named '30daychallenge' if it doesn't exist already
CREATE SCHEMA IF NOT EXISTS "30daychallenge";

-- Set the search path to use the '30daychallenge' schema
SET search_path TO "30daychallenge";

-- Create the salary table
CREATE TABLE IF NOT EXISTS salary (
    emp_id      INTEGER,
    emp_name    VARCHAR(30),
    base_salary INTEGER
);

-- Insert multiple rows into the salary table
INSERT INTO salary (emp_id, emp_name, base_salary) VALUES 
    (1, 'Rohan', 5000),
    (2, 'Alex', 6000),
    (3, 'Maryam', 7000);

-- Create the income table
CREATE TABLE IF NOT EXISTS income (
    id          INTEGER,
    income      VARCHAR(20),
    percentage  INTEGER
);

-- Insert multiple rows into the income table
INSERT INTO income (id, income, percentage) VALUES 
    (1, 'Basic', 100),
    (2, 'Allowance', 4),
    (3, 'Others', 6);

-- Create the deduction table
CREATE TABLE IF NOT EXISTS deduction (
    id          INTEGER,
    deduction   VARCHAR(20),
    percentage  INTEGER
);

-- Insert multiple rows into the deduction table
INSERT INTO deduction (id, deduction, percentage) VALUES 
    (1, 'Insurance', 5),
    (2, 'Health', 6),
    (3, 'House', 4);

-- Create the emp_transaction table
CREATE TABLE IF NOT EXISTS emp_transaction (
    emp_id      INTEGER,
    emp_name    VARCHAR(50),
    trns_type   VARCHAR(20),
    amount      NUMERIC(10,2)
);

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

-- Select statements to view the data
SELECT * FROM salary;
SELECT * FROM income;
SELECT * FROM deduction;
SELECT * FROM emp_transaction;

-- ######################### Solution_1 - PostgreSQL  ##########################
-- Solution Name: Employee Transaction Summary
-- Description: This query generates a summary of employee transactions, including income and deductions.
-- Key Components: 
--   - Common Table Expression (CTE) to summarize transactions
--   - Aggregation of different transaction types
--   - Calculation of gross salary, total deductions, and net pay
-- Notes: This solution uses a CTE for better readability and modularity.

WITH employee_transaction_summary AS (
    SELECT 
        t.emp_name AS employee, 
        SUM(CASE WHEN t.trns_type = 'Basic' THEN t.amount ELSE 0 END) AS basic,
        SUM(CASE WHEN t.trns_type = 'Allowance' THEN t.amount ELSE 0 END) AS allowance,
        SUM(CASE WHEN t.trns_type = 'Others' THEN t.amount ELSE 0 END) AS others,
        SUM(CASE WHEN t.trns_type = 'Insurance' THEN t.amount ELSE 0 END) AS insurance,
        SUM(CASE WHEN t.trns_type = 'Health' THEN t.amount ELSE 0 END) AS health,
        SUM(CASE WHEN t.trns_type = 'House' THEN t.amount ELSE 0 END) AS house
    FROM 
        emp_transaction t
    GROUP BY 
        t.emp_name
)

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
    ((basic + allowance + others) - (insurance + health + house)) AS net_pay
FROM 
    employee_transaction_summary;

-- #############################################################################

-- ######################### Solution_2 - PostgreSQL  ##########################
-- Solution Name: Employee Transaction Summary (Subquery)
-- Description: This query generates a summary of employee transactions, including income and deductions.
-- Key Components: 
--   - Subquery to summarize transactions
--   - Aggregation of different transaction types
--   - Calculation of gross salary, total deductions, and net pay
-- Notes: This solution uses a subquery for summarizing transactions.

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
    ) AS subquery;

-- #############################################################################