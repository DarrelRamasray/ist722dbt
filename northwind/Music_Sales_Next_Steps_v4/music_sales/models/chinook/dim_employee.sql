-- =====================================================================
-- dim_employee.sql
-- Location: music_sales/models/chinook/ in the ist722dbt repository
-- Design:  dim_employee sheet, 1. Bus_MatrixV7_simplified.xlsx
-- Grain:   one row per employee (8 rows)
-- Every column is copied straight from RAW.CHINOOK.EMPLOYEE.
-- =====================================================================

{{ config(materialized='table') }}

with stg_employee as (
    select * from {{ source('chinook', 'employee') }}
)

select
    employeeid   as employeekey,
    employeeid   as employeeid,
    lastname     as lastname,
    firstname    as firstname,
    title        as title,
    reportsto    as reportsto,
    birthdate    as birthdate,
    hiredate     as hiredate,
    address      as address,
    city         as city,
    state        as state,
    country      as country,
    postalcode   as postalcode,
    phone        as phone,
    fax          as fax,
    email        as email

from stg_employee
