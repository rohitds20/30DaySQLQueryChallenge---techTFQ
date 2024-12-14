CREATE DATABASE 30daychallenge;

USE 30daychallenge;

CREATE TABLE IF NOT EXISTS invoice (
    serial_no INT,
    invoice_date DATE
);

SELECT * FROM invoice;

INSERT INTO invoice (serial_no, invoice_date) VALUES 
(330115, STR_TO_DATE('01-Mar-2024','%d-%b-%Y')),
(330120, STR_TO_DATE('01-Mar-2024','%d-%b-%Y')),
(330121, STR_TO_DATE('01-Mar-2024','%d-%b-%Y')),
(330122, STR_TO_DATE('02-Mar-2024','%d-%b-%Y')),
(330125, STR_TO_DATE('02-Mar-2024','%d-%b-%Y'));

##################### Solution - MYSQL  ##########################

WITH RECURSIVE
    serial_numbers AS (
        SELECT MIN(serial_no) AS serial_no
        FROM invoice
        UNION ALL
        SELECT serial_no + 1
        FROM serial_numbers
        WHERE
            serial_no + 1 <= (
                SELECT MAX(serial_no)
                FROM invoice
            )
    )
SELECT
    serial_no as missing_serial_numbers
FROM serial_numbers
WHERE
    serial_no NOT IN(
        SELECT serial_no
        FROM invoice
    );