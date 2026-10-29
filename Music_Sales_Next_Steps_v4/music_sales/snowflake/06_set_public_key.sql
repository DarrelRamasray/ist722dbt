-- =====================================================================
-- 06_set_public_key.sql   (ONLY if Part 3 says you need a new key)
-- Run in: Snowsight > Projects > Workspaces, ONE step at a time
--         (click inside a statement, Ctrl+Enter, Mac: Cmd+Return)
-- What it does: adds your NEW public key to your Snowflake user in the
--   second key slot (RSA_PUBLIC_KEY_2). The key dbt already uses stays in
--   the first slot, so dbt keeps working, and Power BI uses the new one.
-- Before this: run key_pair/make_key_pair.sh (guide Part 3).
-- =====================================================================


-- ---------------------------------------------------------------------
-- STEP 1. Find your exact Snowflake username.
-- ---------------------------------------------------------------------
SELECT CURRENT_USER();


-- ---------------------------------------------------------------------
-- STEP 2. See which key slots are in use.
--   Replace YOUR_USERNAME with the name from STEP 1. If it contains a
--   dot, @ or a hyphen, wrap it in double quotes, e.g. "DARRE.R@SYR.EDU".
--   In the result, look at RSA_PUBLIC_KEY_FP (slot 1, used by dbt) and
--   RSA_PUBLIC_KEY_2_FP (slot 2). If slot 2 already has a value, tell
--   whoever set it up before replacing it; something may be using it.
-- ---------------------------------------------------------------------
DESC USER YOUR_USERNAME;


-- ---------------------------------------------------------------------
-- STEP 3. Put the new public key in slot 2.
--   Replace YOUR_USERNAME as above, and PASTE_PUBLIC_KEY_HERE with the
--   one line from rsa_key_public_oneline.txt. Keep the single quotes.
--   If it fails with "Insufficient privileges", run
--       USE ROLE ACCOUNTADMIN;
--   and then run the ALTER USER line again.
-- ---------------------------------------------------------------------
ALTER USER YOUR_USERNAME SET RSA_PUBLIC_KEY_2 = 'PASTE_PUBLIC_KEY_HERE';


-- ---------------------------------------------------------------------
-- STEP 4. Check it was saved.
--   RSA_PUBLIC_KEY_2_FP should now show a value starting with SHA256: .
--   RSA_PUBLIC_KEY_FP should be unchanged.
-- ---------------------------------------------------------------------
DESC USER YOUR_USERNAME;
