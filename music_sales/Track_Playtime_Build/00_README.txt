Track Playtime build files (Field Guide 3) - Darrel Ramasray, Team DIM Data
==========================================================================

Follow the Claude Doc "Field Guide 3: Build the Track Playtime Star".
It says which file to use in each part, where to paste it, and what you
should see.

data/                       Copy these three files into
                            C:\Users\darre\Documents\chinook_extract (Part 1)
  playlist.csv              Chinook Playlist, 18 rows (your export, renamed)
  playlisttrack.csv         Chinook PlaylistTrack, 8,715 rows (your 10/22 export)
  trackplays.csv            SIMULATED play events, 2,000 rows (see below)

scripts/
  01_extract_playlist_REFERENCE.txt      VS Code / SQL Server - reference only
  02_setup_playtime_raw.txt              Snowsight - Part 2
  03_upload_commands.txt                 Command Prompt - Part 3
  04_load_playtime_raw.txt               Snowsight - Part 4
  05_verify_playtime_raw.txt             Snowsight - Part 4 (19 checks)
  06_dbt_chinook_sources_yml_REPLACE.txt dbt Studio - Part 7 (replaces a file)
  07_dbt_dim_playlist_sql.txt            dbt Studio - Part 7 (new file)
  08_dbt_fact_track_playtime_sql.txt     dbt Studio - Part 7 (new file)
  09_dbt_playtime_models_yml.txt         dbt Studio - Part 7 (new file)
  10_verify_playtime_star.txt            Snowsight - Part 9 (20 checks)
  11_powerbi_playtime_measures.txt       Power BI - Part 11
  12_design_sheets_for_workbook.txt      Excel - Part 5
  13_generate_trackplays_REFERENCE.txt   Python - reference only

About trackplays.csv
--------------------
Chinook has no play-event table, so these plays are SIMULATED. They were
generated with a fixed seed (722), so the file is the same every time, by
13_generate_trackplays_REFERENCE.txt. Every CustomerId, PlaylistId and
TrackId is a real Chinook value, every track is on the playlist it was
played from, and every play date falls inside the existing dim_date range
(2009-01-01 to 2013-12-22). Label any report built on it as simulated.

Never upload your private key file to GitHub.
