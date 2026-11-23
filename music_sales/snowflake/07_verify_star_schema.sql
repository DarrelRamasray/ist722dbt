-- =====================================================================
-- 07_verify_star_schema.sql
-- Run in: Snowsight > Projects > Workspaces
-- What it does: 23 checks of the six Music Sales tables dbt built,
--   against the source data. All 23 rows should say PASS.
-- Updated for Employee Hire (Milestone 3): DIM_DATE now covers full
--   calendar years 2002-01-01 to 2013-12-31 (checks 6, 16 and 17), and
--   STEP 1 and 2 carry Darrel's values. Run STEP 1, 2 and 3 in order.
-- =====================================================================


-- ---------------------------------------------------------------------
-- STEP 1. Find where dbt built the tables.
--   The result should show database_name ANALYTICS and schema_name
--   DBT_DRAMASRAY_CHINOOK. If more than one row appears, that is the
--   one these checks use.
-- ---------------------------------------------------------------------
USE ROLE ACCOUNTADMIN;
SHOW TABLES LIKE 'FACT_SALE' IN ACCOUNT;


-- ---------------------------------------------------------------------
-- STEP 2. Point this file at that schema.
--   STEP 1 should show ANALYTICS and DBT_DRAMASRAY_CHINOOK.
-- ---------------------------------------------------------------------
USE WAREHOUSE TRANSFORMING;
USE SCHEMA ANALYTICS.DBT_DRAMASRAY_CHINOOK;


-- ---------------------------------------------------------------------
-- STEP 3. Run the checks (one result grid).
-- ---------------------------------------------------------------------
WITH checks AS (
    SELECT 1 AS n, 'FACT_SALE row count' AS check_name, 2240 AS expected,
           (SELECT COUNT(*)
              FROM FACT_SALE) AS actual

    UNION ALL SELECT 2, 'DIM_INVOICE row count', 412,
           (SELECT COUNT(*)
              FROM DIM_INVOICE)

    UNION ALL SELECT 3, 'DIM_CUSTOMER row count', 59,
           (SELECT COUNT(*)
              FROM DIM_CUSTOMER)

    UNION ALL SELECT 4, 'DIM_EMPLOYEE row count', 8,
           (SELECT COUNT(*)
              FROM DIM_EMPLOYEE)

    UNION ALL SELECT 5, 'DIM_TRACK row count', 3503,
           (SELECT COUNT(*)
              FROM DIM_TRACK)

    UNION ALL SELECT 6, 'DIM_DATE row count (2002-01-01 to 2013-12-31)', 4383,
           (SELECT COUNT(*)
              FROM DIM_DATE)

    UNION ALL SELECT 7, 'Sum of FACT_SALE.SALEAMOUNT', 2328.60,
           (SELECT SUM(SALEAMOUNT)
              FROM FACT_SALE)

    UNION ALL SELECT 8, 'Sum of FACT_SALE.QUANTITY', 2240,
           (SELECT SUM(QUANTITY)
              FROM FACT_SALE)

    UNION ALL SELECT 9, 'FACT_SALE.INVOICEKEY values missing from DIM_INVOICE', 0,
           (SELECT COUNT(*)
              FROM FACT_SALE f
             WHERE f.INVOICEKEY NOT IN (SELECT INVOICEKEY FROM DIM_INVOICE))

    UNION ALL SELECT 10, 'FACT_SALE.TRACKKEY values missing from DIM_TRACK', 0,
           (SELECT COUNT(*)
              FROM FACT_SALE f
             WHERE f.TRACKKEY NOT IN (SELECT TRACKKEY FROM DIM_TRACK))

    UNION ALL SELECT 11, 'FACT_SALE.CUSTOMERKEY values missing from DIM_CUSTOMER', 0,
           (SELECT COUNT(*)
              FROM FACT_SALE f
             WHERE f.CUSTOMERKEY NOT IN (SELECT CUSTOMERKEY FROM DIM_CUSTOMER))

    UNION ALL SELECT 12, 'FACT_SALE.EMPLOYEEKEY values missing from DIM_EMPLOYEE', 0,
           (SELECT COUNT(*)
              FROM FACT_SALE f
             WHERE f.EMPLOYEEKEY IS NOT NULL
               AND f.EMPLOYEEKEY NOT IN (SELECT EMPLOYEEKEY FROM DIM_EMPLOYEE))

    UNION ALL SELECT 13, 'FACT_SALE.INVOICEDATEKEY values missing from DIM_DATE', 0,
           (SELECT COUNT(*)
              FROM FACT_SALE f
             WHERE f.INVOICEDATEKEY NOT IN (SELECT DATEKEY FROM DIM_DATE))

    UNION ALL SELECT 14, 'FACT_SALE rows with no EMPLOYEEKEY', 0,
           (SELECT COUNT(*)
              FROM FACT_SALE
             WHERE EMPLOYEEKEY IS NULL)

    UNION ALL SELECT 15, 'Distinct invoice dates in FACT_SALE', 354,
           (SELECT COUNT(DISTINCT INVOICEDATEKEY)
              FROM FACT_SALE)

    UNION ALL SELECT 16, 'DIM_DATE first day is 2002-01-01', 1,
           (SELECT IFF(MIN(DATEKEY) = TO_DATE('2002-01-01'), 1, 0)
              FROM DIM_DATE)

    UNION ALL SELECT 17, 'DIM_DATE last day is 2013-12-31', 1,
           (SELECT IFF(MAX(DATEKEY) = TO_DATE('2013-12-31'), 1, 0)
              FROM DIM_DATE)

    UNION ALL SELECT 18, 'DIM_DATE has no missing days', 1,
           (SELECT IFF(COUNT(*) = DATEDIFF(day, MIN(DATEKEY), MAX(DATEKEY)) + 1, 1, 0)
              FROM DIM_DATE)

    UNION ALL SELECT 19, '2009-01-01 is a Thursday (dayofweek 4)', 1,
           (SELECT COUNT(*)
              FROM DIM_DATE
             WHERE DATEKEY = TO_DATE('2009-01-01')
               AND DAYOFWEEK = 4
               AND DAYNAME = 'Thursday')

    UNION ALL SELECT 20, '2013-12-22 is a Sunday (dayofweek 7)', 1,
           (SELECT COUNT(*)
              FROM DIM_DATE
             WHERE DATEKEY = TO_DATE('2013-12-22')
               AND DAYOFWEEK = 7
               AND DAYNAME = 'Sunday')

    UNION ALL SELECT 21, 'DIM_TRACK 1 artist is AC/DC', 1,
           (SELECT COUNT(*)
              FROM DIM_TRACK
             WHERE TRACKKEY = 1
               AND ARTIST = 'AC/DC')

    UNION ALL SELECT 22, 'FACT_SALE.SALEAMOUNT type is NUMBER(21,2)', 1,
           (SELECT IFF(NUMERIC_PRECISION = 21 AND NUMERIC_SCALE = 2, 1, 0)
              FROM INFORMATION_SCHEMA.COLUMNS
             WHERE TABLE_SCHEMA = CURRENT_SCHEMA()
               AND TABLE_NAME = 'FACT_SALE'
               AND COLUMN_NAME = 'SALEAMOUNT')

    UNION ALL SELECT 23, 'FACT_SALE.INVOICEDATEKEY type is DATE', 1,
           (SELECT IFF(DATA_TYPE = 'DATE', 1, 0)
              FROM INFORMATION_SCHEMA.COLUMNS
             WHERE TABLE_SCHEMA = CURRENT_SCHEMA()
               AND TABLE_NAME = 'FACT_SALE'
               AND COLUMN_NAME = 'INVOICEDATEKEY')
)
SELECT n, check_name, expected, actual,
       IFF(actual = expected, 'PASS', 'FAIL') AS result
FROM checks
ORDER BY n;
