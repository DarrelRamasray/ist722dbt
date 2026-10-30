with stg_orders as (
    select
        orderid,
        {{ dbt_utils.generate_surrogate_key(['customerid']) }} as customerkey,
        {{ dbt_utils.generate_surrogate_key(['employeeid']) }} as employeekey,
        replace(to_date(orderdate)::varchar,'-','')::int as orderdatekey
    from {{ source('northwind','Orders') }}
),
stg_order_details as (
    select
        orderid,
        {{ dbt_utils.generate_surrogate_key(['productid']) }} as productkey,
        quantity,
        quantity * unitprice as extendedpriceamount,
        quantity * unitprice * discount as discountamount
    from {{ source('northwind','Order_Details') }}
)
select
    o.orderid,
    o.customerkey,
    o.employeekey,
    o.orderdatekey,
    od.productkey,
    od.quantity,
    od.extendedpriceamount,
    od.discountamount,
    od.extendedpriceamount - od.discountamount as soldamount
from stg_order_details od
    join stg_orders o on o.orderid = od.orderid