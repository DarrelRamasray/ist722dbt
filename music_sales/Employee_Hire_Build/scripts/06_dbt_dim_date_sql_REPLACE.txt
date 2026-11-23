-- =====================================================================
-- dim_date.sql
-- Location: music_sales/models/chinook/ in the ist722dbt repository
-- Design:  dim_date sheet, 1. Bus_MatrixV7_simplified.xlsx
-- Grain:   one row per calendar day, for every full calendar year from
--          the earliest invoice or hire date to the latest one (read
--          from the data, not typed in). Today: 2002-01-01 to 2013-12-31,
--          4,383 days.
--
-- Changed for Employee Hire (Milestone 3): hire dates (2002-2004) are
-- earlier than the first invoice (2009-01-01), so the range now also
-- reads RAW.CHINOOK.EMPLOYEE and runs from 1 January of the first year
-- to 31 December of the last. Every existing invoice and play date is
-- still inside it, so FACT_SALE and FACT_TRACK_PLAYTIME are unaffected.
--
-- Snowflake version of the sheet's SQL Server query:
--   * the day list uses Snowflake's GENERATOR instead of a recursive CTE
--   * QUARTER() and DAYOFWEEKISO() give the same values as the sheet's
--     (MONTH + 2) / 3 and DATEDIFF(...) % 7 + 1 (1 = Monday ... 7 = Sunday)
-- =====================================================================

{{ config(materialized='table') }}

with eventdates as (
    select cast(invoicedate as date) as d
    from {{ source('chinook', 'invoice') }}

    union all

    select cast(hiredate as date) as d
    from {{ source('chinook', 'employee') }}
    where hiredate is not null
),

bounds as (
    select
        date_from_parts(year(min(d)), 1, 1)   as firstdate,
        date_from_parts(year(max(d)), 12, 31) as lastdate
    from eventdates
),

-- 10,000 candidate days (about 27 years); the WHERE clause at the bottom
-- keeps only the days up to the last date
spine as (
    select
        dateadd(day, row_number() over (order by seq4()) - 1, b.firstdate) as d,
        b.lastdate
    from table(generator(rowcount => 10000))
    cross join bounds as b
)

select
    d                                         as datekey,
    cast(year(d) as int)                      as year,
    cast(quarter(d) as int)                   as quarter,
    cast(month(d) as int)                     as month,
    cast(
        case month(d)
            when 1  then 'January'
            when 2  then 'February'
            when 3  then 'March'
            when 4  then 'April'
            when 5  then 'May'
            when 6  then 'June'
            when 7  then 'July'
            when 8  then 'August'
            when 9  then 'September'
            when 10 then 'October'
            when 11 then 'November'
            else 'December'
        end as varchar(9))                    as monthname,
    cast(day(d) as int)                       as dayofmonth,
    cast(dayofweekiso(d) as int)              as dayofweek,
    cast(
        case dayofweekiso(d)
            when 1 then 'Monday'
            when 2 then 'Tuesday'
            when 3 then 'Wednesday'
            when 4 then 'Thursday'
            when 5 then 'Friday'
            when 6 then 'Saturday'
            else 'Sunday'
        end as varchar(9))                    as dayname

from spine
where d <= lastdate
