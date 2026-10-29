-- =====================================================================
-- 03_load.sql
-- Run in: Snowsight > Projects > Workspaces, ONE statement at a time
--         (click inside a statement, Ctrl+Enter, Mac: Cmd+Return)
-- What it does: checks the staged files, then copies each one into its
--   RAW.CHINOOK table. Expected row counts are in each statement's comment.
-- =====================================================================
USE ROLE SYSADMIN;
USE WAREHOUSE COMPUTE_WH;
USE SCHEMA RAW.CHINOOK;

-- A. Confirm the nine files are on the stage (note the exact names)
LIST @CHINOOK_STAGE;

-- B. Count the data rows in each staged file before loading (header row not counted)
SELECT METADATA$FILENAME AS file_name, COUNT(*) AS data_rows
FROM @CHINOOK_STAGE (FILE_FORMAT => 'RAW.CHINOOK.CHINOOK_CSV') t
GROUP BY METADATA$FILENAME
ORDER BY file_name;

-- C. Preview the trickiest file: commas, quotes, backslashes and NULLs in track.csv
SELECT t.$1 AS trackid, t.$2 AS name, t.$6 AS composer
FROM @CHINOOK_STAGE (FILE_FORMAT => 'RAW.CHINOOK.CHINOOK_CSV',
                     PATTERN => '^(.*/)?track[.]csv([.]gz)?$') t
WHERE t.$1 IN ('1', '2', '210', '3435')
ORDER BY TO_NUMBER(t.$1);

-- D. Load each table. PATTERN picks the one file for that table, with or without .gz.
--    ON_ERROR = 'ABORT_STATEMENT' loads nothing for a table if any row fails.

-- ALBUM  <-  album.csv  (expect 347 rows)
COPY INTO ALBUM (
    ALBUMID, TITLE, ARTISTID, _SOURCE_FILE, _LOADED_AT
)
FROM (
  SELECT
    t.$1, t.$2, t.$3, METADATA$FILENAME, METADATA$START_SCAN_TIME
  FROM @CHINOOK_STAGE t
)
PATTERN = '^(.*/)?album[.]csv([.]gz)?$'
FILE_FORMAT = (FORMAT_NAME = 'RAW.CHINOOK.CHINOOK_CSV')
ON_ERROR = 'ABORT_STATEMENT';

-- ARTIST  <-  artist.csv  (expect 275 rows)
COPY INTO ARTIST (
    ARTISTID, NAME, _SOURCE_FILE, _LOADED_AT
)
FROM (
  SELECT
    t.$1, t.$2, METADATA$FILENAME, METADATA$START_SCAN_TIME
  FROM @CHINOOK_STAGE t
)
PATTERN = '^(.*/)?artist[.]csv([.]gz)?$'
FILE_FORMAT = (FORMAT_NAME = 'RAW.CHINOOK.CHINOOK_CSV')
ON_ERROR = 'ABORT_STATEMENT';

-- CUSTOMER  <-  customer.csv  (expect 59 rows)
COPY INTO CUSTOMER (
    CUSTOMERID, FIRSTNAME, LASTNAME, COMPANY, ADDRESS, CITY, STATE, COUNTRY,
    POSTALCODE, PHONE, FAX, EMAIL, SUPPORTREPID, _SOURCE_FILE, _LOADED_AT
)
FROM (
  SELECT
    t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12,
    t.$13, METADATA$FILENAME, METADATA$START_SCAN_TIME
  FROM @CHINOOK_STAGE t
)
PATTERN = '^(.*/)?customer[.]csv([.]gz)?$'
FILE_FORMAT = (FORMAT_NAME = 'RAW.CHINOOK.CHINOOK_CSV')
ON_ERROR = 'ABORT_STATEMENT';

-- EMPLOYEE  <-  employee.csv  (expect 8 rows)
COPY INTO EMPLOYEE (
    EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE, REPORTSTO, BIRTHDATE, HIREDATE,
    ADDRESS, CITY, STATE, COUNTRY, POSTALCODE, PHONE, FAX, EMAIL,
    _SOURCE_FILE, _LOADED_AT
)
FROM (
  SELECT
    t.$1, t.$2, t.$3, t.$4, t.$5,
    TO_TIMESTAMP_NTZ(t.$6, 'YYYY-MM-DD HH24:MI:SS.FF3'),
    TO_TIMESTAMP_NTZ(t.$7, 'YYYY-MM-DD HH24:MI:SS.FF3'), t.$8, t.$9, t.$10,
    t.$11, t.$12, t.$13, t.$14, t.$15, METADATA$FILENAME,
    METADATA$START_SCAN_TIME
  FROM @CHINOOK_STAGE t
)
PATTERN = '^(.*/)?employee[.]csv([.]gz)?$'
FILE_FORMAT = (FORMAT_NAME = 'RAW.CHINOOK.CHINOOK_CSV')
ON_ERROR = 'ABORT_STATEMENT';

-- GENRE  <-  genre.csv  (expect 25 rows)
COPY INTO GENRE (
    GENREID, NAME, _SOURCE_FILE, _LOADED_AT
)
FROM (
  SELECT
    t.$1, t.$2, METADATA$FILENAME, METADATA$START_SCAN_TIME
  FROM @CHINOOK_STAGE t
)
PATTERN = '^(.*/)?genre[.]csv([.]gz)?$'
FILE_FORMAT = (FORMAT_NAME = 'RAW.CHINOOK.CHINOOK_CSV')
ON_ERROR = 'ABORT_STATEMENT';

-- INVOICE  <-  invoice.csv  (expect 412 rows)
COPY INTO INVOICE (
    INVOICEID, CUSTOMERID, INVOICEDATE, BILLINGADDRESS, BILLINGCITY,
    BILLINGSTATE, BILLINGCOUNTRY, BILLINGPOSTALCODE, TOTAL, _SOURCE_FILE,
    _LOADED_AT
)
FROM (
  SELECT
    t.$1, t.$2, TO_TIMESTAMP_NTZ(t.$3, 'YYYY-MM-DD HH24:MI:SS.FF3'), t.$4,
    t.$5, t.$6, t.$7, t.$8, t.$9, METADATA$FILENAME, METADATA$START_SCAN_TIME
  FROM @CHINOOK_STAGE t
)
PATTERN = '^(.*/)?invoice[.]csv([.]gz)?$'
FILE_FORMAT = (FORMAT_NAME = 'RAW.CHINOOK.CHINOOK_CSV')
ON_ERROR = 'ABORT_STATEMENT';

-- INVOICELINE  <-  invoiceline.csv  (expect 2,240 rows)
COPY INTO INVOICELINE (
    INVOICELINEID, INVOICEID, TRACKID, UNITPRICE, QUANTITY, _SOURCE_FILE,
    _LOADED_AT
)
FROM (
  SELECT
    t.$1, t.$2, t.$3, t.$4, t.$5, METADATA$FILENAME, METADATA$START_SCAN_TIME
  FROM @CHINOOK_STAGE t
)
PATTERN = '^(.*/)?invoiceline[.]csv([.]gz)?$'
FILE_FORMAT = (FORMAT_NAME = 'RAW.CHINOOK.CHINOOK_CSV')
ON_ERROR = 'ABORT_STATEMENT';

-- MEDIATYPE  <-  mediatype.csv  (expect 5 rows)
COPY INTO MEDIATYPE (
    MEDIATYPEID, NAME, _SOURCE_FILE, _LOADED_AT
)
FROM (
  SELECT
    t.$1, t.$2, METADATA$FILENAME, METADATA$START_SCAN_TIME
  FROM @CHINOOK_STAGE t
)
PATTERN = '^(.*/)?mediatype[.]csv([.]gz)?$'
FILE_FORMAT = (FORMAT_NAME = 'RAW.CHINOOK.CHINOOK_CSV')
ON_ERROR = 'ABORT_STATEMENT';

-- TRACK  <-  track.csv  (expect 3,503 rows)
COPY INTO TRACK (
    TRACKID, NAME, ALBUMID, MEDIATYPEID, GENREID, COMPOSER, MILLISECONDS,
    BYTES, UNITPRICE, _SOURCE_FILE, _LOADED_AT
)
FROM (
  SELECT
    t.$1, t.$2, t.$3, t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, METADATA$FILENAME,
    METADATA$START_SCAN_TIME
  FROM @CHINOOK_STAGE t
)
PATTERN = '^(.*/)?track[.]csv([.]gz)?$'
FILE_FORMAT = (FORMAT_NAME = 'RAW.CHINOOK.CHINOOK_CSV')
ON_ERROR = 'ABORT_STATEMENT';
