-- =====================================================================
-- 05_check_dbt_role.sql
-- Run in: Snowsight > Projects > Workspaces, ONE step at a time
--         (click inside a statement, Ctrl+Enter, Mac: Cmd+Return)
-- What it does: checks that the role your dbt project uses can read
--   RAW.CHINOOK and can create a schema in the database dbt builds into.
--
-- Before running, replace these with the values you wrote down in Part 1:
--   DBT_ROLE    the Role dbt uses        (for example SYSADMIN)
--   COMPUTE_WH  the Warehouse dbt uses   (often COMPUTE_WH, then leave it)
--   ANALYTICS   the Database dbt uses    (often ANALYTICS, then leave it)
-- =====================================================================


-- ---------------------------------------------------------------------
-- STEP 1. Switch to dbt's role and warehouse.
-- ---------------------------------------------------------------------
USE ROLE DBT_ROLE;
USE WAREHOUSE COMPUTE_WH;


-- ---------------------------------------------------------------------
-- STEP 2. Can the role read RAW.CHINOOK?
--   Expect 2240. An error means it can't (see STEP 4).
-- ---------------------------------------------------------------------
SELECT COUNT(*) AS invoiceline_rows FROM RAW.CHINOOK.INVOICELINE;


-- ---------------------------------------------------------------------
-- STEP 3. Can the role create a schema in dbt's database?
--   Look for a row whose grantee_name is your dbt role with OWNERSHIP,
--   or two rows with USAGE and CREATE SCHEMA.
--   If your dbt role is ACCOUNTADMIN and ACCOUNTADMIN owns the database,
--   that is also fine.
-- ---------------------------------------------------------------------
SHOW GRANTS ON DATABASE ANALYTICS;


-- ---------------------------------------------------------------------
-- STEP 4. ONLY if STEP 2 failed or STEP 3 showed nothing for your role:
--   run these lines (ACCOUNTADMIN can grant on objects it doesn't own).
--   Skip this step if STEP 2 returned 2240 and STEP 3 looked right.
-- ---------------------------------------------------------------------
USE ROLE ACCOUNTADMIN;
GRANT USAGE ON DATABASE RAW TO ROLE DBT_ROLE;
GRANT USAGE ON SCHEMA RAW.CHINOOK TO ROLE DBT_ROLE;
GRANT SELECT ON ALL TABLES IN SCHEMA RAW.CHINOOK TO ROLE DBT_ROLE;
GRANT USAGE, CREATE SCHEMA ON DATABASE ANALYTICS TO ROLE DBT_ROLE;
