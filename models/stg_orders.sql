select
    order_id,
    customer_id,
    cast(order_date as date) as ordered_on,
    status,
    cast(amount as numeric(10, 2)) as amount
from {{ ref('orders') }}
