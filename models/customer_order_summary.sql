-- The one model that actually joins, so the run exercises a dependency edge
-- rather than three unrelated selects. A left join keeps customers with no
-- completed orders, which is what makes the `not_null` test below meaningful:
-- coalesce has to be doing its job for the test to pass.
with customers as (

    select * from {{ ref('stg_customers') }}

),

completed_orders as (

    select *
    from {{ ref('stg_orders') }}
    where status = 'completed'

)

select
    c.customer_id,
    c.full_name,
    c.country,
    coalesce(count(o.order_id), 0) as completed_order_count,
    coalesce(sum(o.amount), 0.00) as lifetime_value
from customers as c
left join completed_orders as o
    on c.customer_id = o.customer_id
group by c.customer_id, c.full_name, c.country
