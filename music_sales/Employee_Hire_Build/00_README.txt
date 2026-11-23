Employee Hire build files (Field Guide 4) - Darrel Ramasray, Team DIM Data
==========================================================================

Follow the Claude Doc "Field Guide 4: Build the Employee Hire Star".
It says which file to use in each part, where to paste it, and what you
should see.

data/                       Copy this file into
                            C:\Users\darre\Documents\chinook_extract (Part 1)
  employeesalary.csv        SIMULATED starting salary per employee, 8 rows

scripts/
  01_setup_hire_raw.txt                     Snowsight - Part 2
  02_upload_commands.txt                    Command Prompt - Part 3
  03_load_hire_raw.txt                      Snowsight - Part 4
  04_verify_hire_raw.txt                    Snowsight - Part 4 (11 checks)
  05_dbt_chinook_sources_yml_REPLACE.txt    dbt Studio - Part 7 (replaces a file)
  06_dbt_dim_date_sql_REPLACE.txt           dbt Studio - Part 7 (replaces a file)
  07_dbt_chinook_models_yml_REPLACE.txt     dbt Studio - Part 7 (replaces a file)
  08_dbt_fact_employee_sql.txt              dbt Studio - Part 7 (new file)
  09_dbt_employee_hire_models_yml.txt       dbt Studio - Part 7 (new file)
  10_snowflake_07_verify_star_schema_REPLACE.txt
                                            dbt Studio - Part 7 (replaces
                                            snowflake/07_verify_star_schema.sql)
                                            and Snowsight - Part 9
  11_verify_employee_hire_star.txt          Snowsight - Part 9 (21 checks)
  12_powerbi_employee_hire_measures.txt     Power BI - Part 11
  13_design_sheets_for_workbook.txt         Excel - Part 5
  14_generate_employeesalary_REFERENCE.txt  Python - reference only

What is real and what is simulated
----------------------------------
Real (RAW.CHINOOK.EMPLOYEE, loaded in Milestone 2): who was hired, the
hire date, the birth date (so age at hire), title and manager.
SIMULATED (employeesalary.csv): the starting salary, and so the salary
band. Chinook has no salary data. The salaries were generated with a
fixed seed (722) by 14_generate_employeesalary_REFERENCE.txt, inside a
fixed range per title (General Manager 120,000-140,000; Sales and IT
Manager 85,000-99,500; IT Staff 55,000-65,000; Sales Support Agent
42,000-52,000; CAD per year). Label every salary figure as simulated.

Never upload your private key file to GitHub.
