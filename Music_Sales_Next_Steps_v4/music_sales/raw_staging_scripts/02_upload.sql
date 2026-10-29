-- =====================================================================
-- 02_upload.sql
-- Run in: a terminal with the Snowflake CLI, from the chinook_extract folder:
--     cd %USERPROFILE%\Documents\chinook_extract
--     snow sql -f 02_upload.sql -c my_snowflake
-- What it does: uploads all nine CSV files to RAW.CHINOOK.CHINOOK_STAGE.
--
-- Replace YOUR_USERNAME with your Windows user name (for example darre).
-- Keep the single quotes. Use forward slashes, even on Windows.
-- On a Mac, use the commented version at the bottom instead.
-- =====================================================================

PUT 'file://C:/Users/YOUR_USERNAME/Documents/chinook_extract/*.csv'
    @RAW.CHINOOK.CHINOOK_STAGE
    AUTO_COMPRESS = TRUE
    OVERWRITE = TRUE;


-- macOS version (remove the two dashes at the start of each line to use it,
-- and delete the Windows version above):
-- PUT 'file:///Users/YOUR_USERNAME/Documents/chinook_extract/*.csv'
--     @RAW.CHINOOK.CHINOOK_STAGE
--     AUTO_COMPRESS = TRUE
--     OVERWRITE = TRUE;
