-- =====================================================================
-- fact_employee.sql
-- Location: music_sales/models/chinook/ in the ist722dbt repository
-- Design:  fact_employee sheet, 1. Bus Matrix workbook
-- Grain:   one row per employee hired (8 rows)
-- Sources: RAW.CHINOOK.EMPLOYEE (real: hire date, birth date) and
--          RAW.CHINOOK.EMPLOYEESALARY (SIMULATED starting salary;
--          Chinook has no salary data).
-- Reuses:  dim_employee and dim_date from Music Sales (conformed).
-- =====================================================================

{{ config(materialized='table') }}

with stg_employee as (
    select * from {{ source('chinook', 'employee') }}
),

stg_employeesalary as (
    select * from {{ source('chinook', 'employeesalary') }}
),

hires as (
    select
        e.employeeid,
        cast(e.hiredate as date)   as hiredate,
        cast(e.birthdate as date)  as birthdate,
        s.startingsalary
    from stg_employee as e

    -- Every employee has a salary row (check 4 in 04_verify_hire_raw),
    -- so the inner join loses no one.
    inner join stg_employeesalary as s
        on s.employeeid = e.employeeid

    -- The grain is one row per employee HIRED: an employee with no hire
    -- date is not a hire. None today (check 8 in 04_verify_hire_raw).
    where e.hiredate is not null
)

select
    h.employeeid                                           as employeeid,
    h.employeeid                                           as employeekey,
    h.hiredate                                             as hiredatekey,
    cast(1 as int)                                         as hirecount,

    -- whole years between birth date and hire date: count the year
    -- boundaries crossed, minus 1 if the birthday had not yet come that
    -- year. NULL if the birth date is NULL (Employee.BirthDate allows it).
    cast(
        datediff(year, h.birthdate, h.hiredate)
        - iff(dateadd(year, datediff(year, h.birthdate, h.hiredate), h.birthdate) > h.hiredate, 1, 0)
        as int)                                            as ageathire,

    cast(h.startingsalary as int)                          as startingsalary,
    cast(
        case
            when h.startingsalary < 50000  then '1: Under 50K'
            when h.startingsalary < 75000  then '2: 50K to 75K'
            when h.startingsalary < 100000 then '3: 75K to 100K'
            else '4: 100K and over'
        end as varchar(20))                                as salaryband

from hires as h
