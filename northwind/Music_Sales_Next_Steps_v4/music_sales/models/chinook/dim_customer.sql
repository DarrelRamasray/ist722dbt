-- =====================================================================
-- dim_customer.sql
-- Location: music_sales/models/chinook/ in the ist722dbt repository
-- Design:  dim_customer sheet, 1. Bus_MatrixV7_simplified.xlsx
-- Grain:   one row per customer (59 rows)
-- Every column is copied straight from RAW.CHINOOK.CUSTOMER.
-- =====================================================================

{{ config(materialized='table') }}

with stg_customer as (
    select * from {{ source('chinook', 'customer') }}
)

select
    customerid     as customerkey,
    customerid     as customerid,
    firstname      as firstname,
    lastname       as lastname,
    company        as company,
    address        as address,
    city           as city,
    state          as state,
    country        as country,
    postalcode     as postalcode,
    phone          as phone,
    fax            as fax,
    email          as email,
    supportrepid   as supportrepid

from stg_customer
