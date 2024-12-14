CREATE DATABASE 30daychallenge;

USE 30daychallenge;

-- Create the Day_Indicator table

CREATE TABLE IF NOT EXISTS Day_Indicator (
    Product_ID     VARCHAR(10),
    Day_Indicator  VARCHAR(7),
    Dates          DATE
);


##################### Solution - MYSQL  ########################## 

-- Insert multiple rows into the Day_Indicator table
INSERT INTO Day_Indicator (Product_ID, Day_Indicator, Dates) VALUES
    ('AP755', '1010101', '2024-03-04'),
    ('AP755', '1010101', '2024-03-05'),
    ('AP755', '1010101', '2024-03-06'),
    ('AP755', '1010101', '2024-03-07'),
    ('AP755', '1010101', '2024-03-08'),
    ('AP755', '1010101', '2024-03-09'),
    ('AP755', '1010101', '2024-03-10'),
    ('XQ802', '1000110', '2024-03-04'),
    ('XQ802', '1000110', '2024-03-05'),
    ('XQ802', '1000110', '2024-03-06'),
    ('XQ802', '1000110', '2024-03-07'),
    ('XQ802', '1000110', '2024-03-08'),
    ('XQ802', '1000110', '2024-03-09'),
    ('XQ802', '1000110', '2024-03-10');

select * from Day_Indicator;


-- Find the relevant dates for each product

SELECT 
    PRODUCT_ID, 
    DAY_INDICATOR, 
    DATES
FROM 
    Day_Indicator
WHERE 
    SUBSTRING(
        DAY_INDICATOR, 
        CASE 
            WHEN DAYOFWEEK(DATES) = 1 THEN 7  -- Sunday
            ELSE DAYOFWEEK(DATES) - 1         -- Monday to Saturday
        END, 
        1
    ) = '1';

##################### Solution - PostgreSQL  ########################## 

-- Insert multiple rows into the Day_Indicator table
INSERT INTO Day_Indicator (Product_ID, Day_Indicator, Dates) VALUES
    ('AP755', '1010101', TO_DATE('04-Mar-2024', 'dd-mon-yyyy')),
    ('AP755', '1010101', TO_DATE('05-Mar-2024', 'dd-mon-yyyy')),
    ('AP755', '1010101', TO_DATE('06-Mar-2024', 'dd-mon-yyyy')),
    ('AP755', '1010101', TO_DATE('07-Mar-2024', 'dd-mon-yyyy')),
    ('AP755', '1010101', TO_DATE('08-Mar-2024', 'dd-mon-yyyy')),
    ('AP755', '1010101', TO_DATE('09-Mar-2024', 'dd-mon-yyyy')),
    ('AP755', '1010101', TO_DATE('10-Mar-2024', 'dd-mon-yyyy')),
    ('XQ802', '1000110', TO_DATE('04-Mar-2024', 'dd-mon-yyyy')),
    ('XQ802', '1000110', TO_DATE('05-Mar-2024', 'dd-mon-yyyy')),
    ('XQ802', '1000110', TO_DATE('06-Mar-2024', 'dd-mon-yyyy')),
    ('XQ802', '1000110', TO_DATE('07-Mar-2024', 'dd-mon-yyyy')),
    ('XQ802', '1000110', TO_DATE('08-Mar-2024', 'dd-mon-yyyy')),
    ('XQ802', '1000110', TO_DATE('09-Mar-2024', 'dd-mon-yyyy')),
    ('XQ802', '1000110', TO_DATE('10-Mar-2024', 'dd-mon-yyyy'));

SELECT * FROM Day_Indicator;

-- Find the relevant dates for each product
SELECT 
    product_id, 
    day_indicator, 
    dates
FROM (
    SELECT 
        *, 
        EXTRACT('ISODOW' FROM dates) AS dow,  -- Extract day of the week (ISO format)
        CASE 
            WHEN SUBSTRING(day_indicator, EXTRACT('ISODOW' FROM dates)::int, 1) = '1' 
            THEN 'Include' 
            ELSE 'Exclude' 
        END AS flag
    FROM Day_Indicator
) AS day_status
WHERE flag = 'Include';


##################### Solution - MSSQL Server  ########################## 

-- Insert multiple rows into the Day_Indicator table
INSERT INTO Day_Indicator (Product_ID, Day_Indicator, Dates) VALUES
    ('AP755', '1010101', CONVERT(DATE, '04-Mar-2024', 102)),
    ('AP755', '1010101', CONVERT(DATE, '05-Mar-2024', 102)),
    ('AP755', '1010101', CONVERT(DATE, '06-Mar-2024', 102)),
    ('AP755', '1010101', CONVERT(DATE, '07-Mar-2024', 102)),
    ('AP755', '1010101', CONVERT(DATE, '08-Mar-2024', 102)),
    ('AP755', '1010101', CONVERT(DATE, '09-Mar-2024', 102)),
    ('AP755', '1010101', CONVERT(DATE, '10-Mar-2024', 102)),
    ('XQ802', '1000110', CONVERT(DATE, '04-Mar-2024', 102)),
    ('XQ802', '1000110', CONVERT(DATE, '05-Mar-2024', 102)),
    ('XQ802', '1000110', CONVERT(DATE, '06-Mar-2024', 102)),
    ('XQ802', '1000110', CONVERT(DATE, '07-Mar-2024', 102)),
    ('XQ802', '1000110', CONVERT(DATE, '08-Mar-2024', 102)),
    ('XQ802', '1000110', CONVERT(DATE, '09-Mar-2024', 102)),
    ('XQ802', '1000110', CONVERT(DATE, '10-Mar-2024', 102));

SELECT * FROM Day_Indicator;

-- Find the relevant dates for each product
SELECT 
    product_id, 
    day_indicator, 
    dates
FROM (
    SELECT 
        *, 
        CASE 
            WHEN SUBSTRING(day_indicator, (((DATEPART(dw, dates) + 5) % 7) + 1), 1) = '1' 
            THEN 'Include' 
            ELSE 'Exclude' 
        END AS flag
    FROM Day_Indicator
) AS day_status
WHERE flag = 'Include';
