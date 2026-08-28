-- Light rename over the seed, the shape a real project's staging layer has.
select
    customer_id,
    first_name,
    last_name,
    first_name || ' ' || last_name as full_name,
    country,
    cast(signup_date as date) as signed_up_on
from {{ ref('customers') }}
