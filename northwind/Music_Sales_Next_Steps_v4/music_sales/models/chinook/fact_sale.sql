-- =====================================================================
-- fact_sale.sql
-- Location: music_sales/models/chinook/ in the ist722dbt repository
-- Design:  fact_sale sheet, 1. Bus_MatrixV7_simplified.xlsx
-- Grain:   one row per track sold on an invoice line
-- =====================================================================

{{ config(materialized='table') }}

with stg_invoiceline as (
    select * from {{ source('chinook', 'invoiceline') }}
),

stg_invoice as (
    select * from {{ source('chinook', 'invoice') }}
),

stg_customer as (
    select * from {{ source('chinook', 'customer') }}
)

select
    il.invoicelineid                                   as invoicelineid,
    il.invoiceid                                       as invoiceid,
    il.invoiceid                                       as invoicekey,
    il.trackid                                         as trackkey,
    i.customerid                                       as customerkey,
    c.supportrepid                                     as employeekey,
    cast(i.invoicedate as date)                        as invoicedatekey,
    il.unitprice                                       as unitprice,
    il.quantity                                        as quantity,
    cast(il.unitprice * il.quantity as number(21, 2))  as saleamount

from stg_invoiceline as il

-- Inner joins lose no rows: InvoiceLine.InvoiceId and Invoice.CustomerId
-- are NOT NULL with enforced foreign keys in the source (Query 1, Query 2)
inner join stg_invoice as i
    on i.invoiceid = il.invoiceid

inner join stg_customer as c
    on c.customerid = i.customerid
