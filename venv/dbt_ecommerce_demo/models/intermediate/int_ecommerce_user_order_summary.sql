-- models/intermediate/int_user_order_summary.sql

with stg_ecommerce__orders as (
    select * from {{ ref('stg_ecommerce__orders') }}
),

--perform aggregation functions from stg_ecommerce__orders
user_order_summary as (
    select
        user_id,
        count(order_id) as total_orders,
        avg(num_items_ordered) as avg_items_per_order,
        min(created_at) as first_order_date,
        max(created_at) as last_order_date
    from
        stg_ecommerce__orders
    group by
        user_id
)

select * from user_order_summary
