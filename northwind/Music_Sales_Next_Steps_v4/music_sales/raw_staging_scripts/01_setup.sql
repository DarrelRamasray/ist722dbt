-- =====================================================================
-- 01_setup.sql
-- Run in: Snowsight > Projects > Workspaces (run the whole file:
--         Ctrl+Shift+Enter, Mac: Cmd+Shift+Return)
-- What it does: creates the RAW database, RAW.CHINOOK schema, the
--   CHINOOK_CSV file format, the CHINOOK_STAGE stage and nine empty tables.
--
-- If you see "Insufficient privileges to operate on database 'RAW'",
-- RAW already exists and belongs to another role. Run this once as
-- the owner role (usually ACCOUNTADMIN), then re-run this file:
--     USE ROLE ACCOUNTADMIN;
--     GRANT USAGE, CREATE SCHEMA ON DATABASE RAW TO ROLE SYSADMIN;
--
-- Re-running this file EMPTIES the nine tables (files on the stage are kept).
-- =====================================================================
USE ROLE SYSADMIN;
USE WAREHOUSE COMPUTE_WH;

CREATE DATABASE IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS RAW.CHINOOK;
USE SCHEMA RAW.CHINOOK;

-- How Snowflake should read the nine CSV files
CREATE OR REPLACE FILE FORMAT CHINOOK_CSV
  TYPE = 'CSV'
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  ESCAPE_UNENCLOSED_FIELD = NONE      -- read \ as an ordinary character (4 track names contain it)
  NULL_IF = ('NULL', '')              -- the word NULL or an empty field becomes a real NULL
  EMPTY_FIELD_AS_NULL = TRUE
  TRIM_SPACE = FALSE                  -- keep every value exactly as extracted
  ENCODING = 'UTF8'
  TIMESTAMP_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF3'
  ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE;

-- Snowflake-managed storage for the files.
-- IF NOT EXISTS means re-running this script never deletes files you already uploaded.
CREATE STAGE IF NOT EXISTS CHINOOK_STAGE;

-- One RAW table per source table: same columns, same order, data types from the
-- Query 1 schema export, NOT NULL where the source column is NOT NULL.
-- _SOURCE_FILE and _LOADED_AT record which file each row came from and when it was loaded.
CREATE OR REPLACE TABLE ALBUM (
  ALBUMID       INT NOT NULL,
  TITLE         VARCHAR(160) NOT NULL,
  ARTISTID      INT NOT NULL,
  _SOURCE_FILE  VARCHAR,
  _LOADED_AT    TIMESTAMP_LTZ
);

CREATE OR REPLACE TABLE ARTIST (
  ARTISTID      INT NOT NULL,
  NAME          VARCHAR(120),
  _SOURCE_FILE  VARCHAR,
  _LOADED_AT    TIMESTAMP_LTZ
);

CREATE OR REPLACE TABLE CUSTOMER (
  CUSTOMERID    INT NOT NULL,
  FIRSTNAME     VARCHAR(40) NOT NULL,
  LASTNAME      VARCHAR(20) NOT NULL,
  COMPANY       VARCHAR(80),
  ADDRESS       VARCHAR(70),
  CITY          VARCHAR(40),
  STATE         VARCHAR(40),
  COUNTRY       VARCHAR(40),
  POSTALCODE    VARCHAR(10),
  PHONE         VARCHAR(24),
  FAX           VARCHAR(24),
  EMAIL         VARCHAR(60) NOT NULL,
  SUPPORTREPID  INT,
  _SOURCE_FILE  VARCHAR,
  _LOADED_AT    TIMESTAMP_LTZ
);

CREATE OR REPLACE TABLE EMPLOYEE (
  EMPLOYEEID    INT NOT NULL,
  LASTNAME      VARCHAR(20) NOT NULL,
  FIRSTNAME     VARCHAR(20) NOT NULL,
  TITLE         VARCHAR(30),
  REPORTSTO     INT,
  BIRTHDATE     TIMESTAMP_NTZ,
  HIREDATE      TIMESTAMP_NTZ,
  ADDRESS       VARCHAR(70),
  CITY          VARCHAR(40),
  STATE         VARCHAR(40),
  COUNTRY       VARCHAR(40),
  POSTALCODE    VARCHAR(10),
  PHONE         VARCHAR(24),
  FAX           VARCHAR(24),
  EMAIL         VARCHAR(60),
  _SOURCE_FILE  VARCHAR,
  _LOADED_AT    TIMESTAMP_LTZ
);

CREATE OR REPLACE TABLE GENRE (
  GENREID       INT NOT NULL,
  NAME          VARCHAR(120),
  _SOURCE_FILE  VARCHAR,
  _LOADED_AT    TIMESTAMP_LTZ
);

CREATE OR REPLACE TABLE INVOICE (
  INVOICEID          INT NOT NULL,
  CUSTOMERID         INT NOT NULL,
  INVOICEDATE        TIMESTAMP_NTZ NOT NULL,
  BILLINGADDRESS     VARCHAR(70),
  BILLINGCITY        VARCHAR(40),
  BILLINGSTATE       VARCHAR(40),
  BILLINGCOUNTRY     VARCHAR(40),
  BILLINGPOSTALCODE  VARCHAR(10),
  TOTAL              NUMBER(10,2) NOT NULL,
  _SOURCE_FILE       VARCHAR,
  _LOADED_AT         TIMESTAMP_LTZ
);

CREATE OR REPLACE TABLE INVOICELINE (
  INVOICELINEID  INT NOT NULL,
  INVOICEID      INT NOT NULL,
  TRACKID        INT NOT NULL,
  UNITPRICE      NUMBER(10,2) NOT NULL,
  QUANTITY       INT NOT NULL,
  _SOURCE_FILE   VARCHAR,
  _LOADED_AT     TIMESTAMP_LTZ
);

CREATE OR REPLACE TABLE MEDIATYPE (
  MEDIATYPEID   INT NOT NULL,
  NAME          VARCHAR(120),
  _SOURCE_FILE  VARCHAR,
  _LOADED_AT    TIMESTAMP_LTZ
);

CREATE OR REPLACE TABLE TRACK (
  TRACKID       INT NOT NULL,
  NAME          VARCHAR(200) NOT NULL,
  ALBUMID       INT,
  MEDIATYPEID   INT NOT NULL,
  GENREID       INT,
  COMPOSER      VARCHAR(220),
  MILLISECONDS  INT NOT NULL,
  BYTES         INT,
  UNITPRICE     NUMBER(10,2) NOT NULL,
  _SOURCE_FILE  VARCHAR,
  _LOADED_AT    TIMESTAMP_LTZ
);
