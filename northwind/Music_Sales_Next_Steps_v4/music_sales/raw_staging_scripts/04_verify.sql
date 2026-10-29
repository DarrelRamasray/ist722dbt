-- =====================================================================
-- 04_verify.sql
-- Run in: Snowsight > Projects > Workspaces (run the whole file:
--         Ctrl+Shift+Enter, Mac: Cmd+Shift+Return)
-- What it does: 52 checks of RAW.CHINOOK against the source.
--   All 52 rows should say PASS.
-- =====================================================================
-- One row per check. Every expected value comes from the source: row counts from your
-- Query 3 results, keys from Query 2, and totals, NULL counts and sample values from the data.
USE ROLE SYSADMIN;
USE WAREHOUSE COMPUTE_WH;
USE SCHEMA RAW.CHINOOK;

WITH checks AS (
    SELECT 1 AS n, 'ALBUM row count' AS check_name, 347 AS expected,
           (SELECT COUNT(*)
              FROM ALBUM) AS actual

    UNION ALL SELECT 2, 'ARTIST row count', 275,
           (SELECT COUNT(*)
              FROM ARTIST)

    UNION ALL SELECT 3, 'CUSTOMER row count', 59,
           (SELECT COUNT(*)
              FROM CUSTOMER)

    UNION ALL SELECT 4, 'EMPLOYEE row count', 8,
           (SELECT COUNT(*)
              FROM EMPLOYEE)

    UNION ALL SELECT 5, 'GENRE row count', 25,
           (SELECT COUNT(*)
              FROM GENRE)

    UNION ALL SELECT 6, 'INVOICE row count', 412,
           (SELECT COUNT(*)
              FROM INVOICE)

    UNION ALL SELECT 7, 'INVOICELINE row count', 2240,
           (SELECT COUNT(*)
              FROM INVOICELINE)

    UNION ALL SELECT 8, 'MEDIATYPE row count', 5,
           (SELECT COUNT(*)
              FROM MEDIATYPE)

    UNION ALL SELECT 9, 'TRACK row count', 3503,
           (SELECT COUNT(*)
              FROM TRACK)

    UNION ALL SELECT 10, 'Duplicate ALBUMID values in ALBUM', 0,
           (SELECT COUNT(*) - COUNT(DISTINCT ALBUMID)
              FROM ALBUM)

    UNION ALL SELECT 11, 'Duplicate ARTISTID values in ARTIST', 0,
           (SELECT COUNT(*) - COUNT(DISTINCT ARTISTID)
              FROM ARTIST)

    UNION ALL SELECT 12, 'Duplicate CUSTOMERID values in CUSTOMER', 0,
           (SELECT COUNT(*) - COUNT(DISTINCT CUSTOMERID)
              FROM CUSTOMER)

    UNION ALL SELECT 13, 'Duplicate EMPLOYEEID values in EMPLOYEE', 0,
           (SELECT COUNT(*) - COUNT(DISTINCT EMPLOYEEID)
              FROM EMPLOYEE)

    UNION ALL SELECT 14, 'Duplicate GENREID values in GENRE', 0,
           (SELECT COUNT(*) - COUNT(DISTINCT GENREID)
              FROM GENRE)

    UNION ALL SELECT 15, 'Duplicate INVOICEID values in INVOICE', 0,
           (SELECT COUNT(*) - COUNT(DISTINCT INVOICEID)
              FROM INVOICE)

    UNION ALL SELECT 16, 'Duplicate INVOICELINEID values in INVOICELINE', 0,
           (SELECT COUNT(*) - COUNT(DISTINCT INVOICELINEID)
              FROM INVOICELINE)

    UNION ALL SELECT 17, 'Duplicate MEDIATYPEID values in MEDIATYPE', 0,
           (SELECT COUNT(*) - COUNT(DISTINCT MEDIATYPEID)
              FROM MEDIATYPE)

    UNION ALL SELECT 18, 'Duplicate TRACKID values in TRACK', 0,
           (SELECT COUNT(*) - COUNT(DISTINCT TRACKID)
              FROM TRACK)

    UNION ALL SELECT 19, 'Sum of INVOICELINE UnitPrice x Quantity', 2328.60,
           (SELECT SUM(UNITPRICE * QUANTITY)
              FROM INVOICELINE)

    UNION ALL SELECT 20, 'Sum of INVOICE Total', 2328.60,
           (SELECT SUM(TOTAL)
              FROM INVOICE)

    UNION ALL SELECT 21, 'NULLs in CUSTOMER.COMPANY', 49,
           (SELECT COUNT(*)
              FROM CUSTOMER
             WHERE COMPANY IS NULL)

    UNION ALL SELECT 22, 'NULLs in CUSTOMER.STATE', 29,
           (SELECT COUNT(*)
              FROM CUSTOMER
             WHERE STATE IS NULL)

    UNION ALL SELECT 23, 'NULLs in CUSTOMER.POSTALCODE', 4,
           (SELECT COUNT(*)
              FROM CUSTOMER
             WHERE POSTALCODE IS NULL)

    UNION ALL SELECT 24, 'NULLs in CUSTOMER.PHONE', 1,
           (SELECT COUNT(*)
              FROM CUSTOMER
             WHERE PHONE IS NULL)

    UNION ALL SELECT 25, 'NULLs in CUSTOMER.FAX', 47,
           (SELECT COUNT(*)
              FROM CUSTOMER
             WHERE FAX IS NULL)

    UNION ALL SELECT 26, 'NULLs in EMPLOYEE.REPORTSTO', 1,
           (SELECT COUNT(*)
              FROM EMPLOYEE
             WHERE REPORTSTO IS NULL)

    UNION ALL SELECT 27, 'NULLs in INVOICE.BILLINGSTATE', 202,
           (SELECT COUNT(*)
              FROM INVOICE
             WHERE BILLINGSTATE IS NULL)

    UNION ALL SELECT 28, 'NULLs in INVOICE.BILLINGPOSTALCODE', 28,
           (SELECT COUNT(*)
              FROM INVOICE
             WHERE BILLINGPOSTALCODE IS NULL)

    UNION ALL SELECT 29, 'NULLs in TRACK.COMPOSER', 978,
           (SELECT COUNT(*)
              FROM TRACK
             WHERE COMPOSER IS NULL)

    UNION ALL SELECT 30, 'CUSTOMER 49 first name is ''Stanisław''', 1,
           (SELECT COUNT(*)
              FROM CUSTOMER
             WHERE CUSTOMERID = 49
               AND FIRSTNAME = 'Stanisław')

    UNION ALL SELECT 31, 'CUSTOMER 54 city length, trailing space kept', 10,
           (SELECT LENGTH(CITY)
              FROM CUSTOMER
             WHERE CUSTOMERID = 54)

    UNION ALL SELECT 32, 'TRACK 210 name keeps its double quotes', 1,
           (SELECT COUNT(*)
              FROM TRACK
             WHERE TRACKID = 210
               AND NAME = 'Texto "Verdade Tropical"')

    UNION ALL SELECT 33, 'TRACK 3435 name keeps both backslashes', 2,
           (SELECT LENGTH(NAME) - LENGTH(REPLACE(NAME, CHR(92), ''))
              FROM TRACK
             WHERE TRACKID = 3435)

    UNION ALL SELECT 34, 'First invoice date is 2009-01-01', 1,
           (SELECT IFF(MIN(INVOICEDATE) = TO_TIMESTAMP_NTZ('2009-01-01 00:00:00'), 1, 0)
              FROM INVOICE)

    UNION ALL SELECT 35, 'Last invoice date is 2013-12-22', 1,
           (SELECT IFF(MAX(INVOICEDATE) = TO_TIMESTAMP_NTZ('2013-12-22 00:00:00'), 1, 0)
              FROM INVOICE)

    UNION ALL SELECT 36, 'INVOICELINE.INVOICEID values missing from INVOICE', 0,
           (SELECT COUNT(*)
              FROM INVOICELINE c
             WHERE c.INVOICEID IS NOT NULL
               AND c.INVOICEID NOT IN (SELECT INVOICEID FROM INVOICE))

    UNION ALL SELECT 37, 'INVOICELINE.TRACKID values missing from TRACK', 0,
           (SELECT COUNT(*)
              FROM INVOICELINE c
             WHERE c.TRACKID IS NOT NULL
               AND c.TRACKID NOT IN (SELECT TRACKID FROM TRACK))

    UNION ALL SELECT 38, 'INVOICE.CUSTOMERID values missing from CUSTOMER', 0,
           (SELECT COUNT(*)
              FROM INVOICE c
             WHERE c.CUSTOMERID IS NOT NULL
               AND c.CUSTOMERID NOT IN (SELECT CUSTOMERID FROM CUSTOMER))

    UNION ALL SELECT 39, 'CUSTOMER.SUPPORTREPID values missing from EMPLOYEE', 0,
           (SELECT COUNT(*)
              FROM CUSTOMER c
             WHERE c.SUPPORTREPID IS NOT NULL
               AND c.SUPPORTREPID NOT IN (SELECT EMPLOYEEID FROM EMPLOYEE))

    UNION ALL SELECT 40, 'TRACK.ALBUMID values missing from ALBUM', 0,
           (SELECT COUNT(*)
              FROM TRACK c
             WHERE c.ALBUMID IS NOT NULL
               AND c.ALBUMID NOT IN (SELECT ALBUMID FROM ALBUM))

    UNION ALL SELECT 41, 'TRACK.GENREID values missing from GENRE', 0,
           (SELECT COUNT(*)
              FROM TRACK c
             WHERE c.GENREID IS NOT NULL
               AND c.GENREID NOT IN (SELECT GENREID FROM GENRE))

    UNION ALL SELECT 42, 'TRACK.MEDIATYPEID values missing from MEDIATYPE', 0,
           (SELECT COUNT(*)
              FROM TRACK c
             WHERE c.MEDIATYPEID IS NOT NULL
               AND c.MEDIATYPEID NOT IN (SELECT MEDIATYPEID FROM MEDIATYPE))

    UNION ALL SELECT 43, 'ALBUM.ARTISTID values missing from ARTIST', 0,
           (SELECT COUNT(*)
              FROM ALBUM c
             WHERE c.ARTISTID IS NOT NULL
               AND c.ARTISTID NOT IN (SELECT ARTISTID FROM ARTIST))

    UNION ALL SELECT 44, 'ALBUM rows missing _SOURCE_FILE or _LOADED_AT', 0,
           (SELECT COUNT(*)
              FROM ALBUM
             WHERE _SOURCE_FILE IS NULL OR _LOADED_AT IS NULL)

    UNION ALL SELECT 45, 'ARTIST rows missing _SOURCE_FILE or _LOADED_AT', 0,
           (SELECT COUNT(*)
              FROM ARTIST
             WHERE _SOURCE_FILE IS NULL OR _LOADED_AT IS NULL)

    UNION ALL SELECT 46, 'CUSTOMER rows missing _SOURCE_FILE or _LOADED_AT', 0,
           (SELECT COUNT(*)
              FROM CUSTOMER
             WHERE _SOURCE_FILE IS NULL OR _LOADED_AT IS NULL)

    UNION ALL SELECT 47, 'EMPLOYEE rows missing _SOURCE_FILE or _LOADED_AT', 0,
           (SELECT COUNT(*)
              FROM EMPLOYEE
             WHERE _SOURCE_FILE IS NULL OR _LOADED_AT IS NULL)

    UNION ALL SELECT 48, 'GENRE rows missing _SOURCE_FILE or _LOADED_AT', 0,
           (SELECT COUNT(*)
              FROM GENRE
             WHERE _SOURCE_FILE IS NULL OR _LOADED_AT IS NULL)

    UNION ALL SELECT 49, 'INVOICE rows missing _SOURCE_FILE or _LOADED_AT', 0,
           (SELECT COUNT(*)
              FROM INVOICE
             WHERE _SOURCE_FILE IS NULL OR _LOADED_AT IS NULL)

    UNION ALL SELECT 50, 'INVOICELINE rows missing _SOURCE_FILE or _LOADED_AT', 0,
           (SELECT COUNT(*)
              FROM INVOICELINE
             WHERE _SOURCE_FILE IS NULL OR _LOADED_AT IS NULL)

    UNION ALL SELECT 51, 'MEDIATYPE rows missing _SOURCE_FILE or _LOADED_AT', 0,
           (SELECT COUNT(*)
              FROM MEDIATYPE
             WHERE _SOURCE_FILE IS NULL OR _LOADED_AT IS NULL)

    UNION ALL SELECT 52, 'TRACK rows missing _SOURCE_FILE or _LOADED_AT', 0,
           (SELECT COUNT(*)
              FROM TRACK
             WHERE _SOURCE_FILE IS NULL OR _LOADED_AT IS NULL)
)
SELECT n, check_name, expected, actual,
       IFF(actual = expected, 'PASS', 'FAIL') AS result
FROM checks
ORDER BY n;
