# Music Sales star schema (IST 722 team project)

dbt project for the Music Sales business process, built on the Chinook
data staged in Snowflake (RAW.CHINOOK).

| Folder | What it holds |
| --- | --- |
| `models/chinook/` | dbt models: `fact_sale` and five dimensions, with sources and tests |
| `raw_staging_scripts/` | SQL used to extract Chinook from SQL Server and load RAW.CHINOOK |
| `snowflake/` | Snowflake checks for the dbt role, key setup and star-schema verification |
| `key_pair/` | Scripts to create and check a Snowflake key pair (no keys are stored here) |
| `powerbi/` | DAX measures for the Power BI report |

Design: `1. Bus_MatrixV7_simplified.xlsx` (fact_sale, dim_date, dim_employee,
dim_customer, dim_invoice, dim_track).
