-- models/marts/user_order_metrics.sql

with int_ecommerce_user_order_summary as (
    select * from {{ ref('int_ecommerce_user_order_summary') }}
),

user_order_metrics as (

    select
        user_id,
        total_orders,
        avg_items_per_order,
        first_order_date,
        last_order_date,
        -- Calculate the total items ordered by the user
        total_orders * avg_items_per_order as total_items,
        -- Calculate the duration between the first and last order in days
        date_diff(last_order_date, first_order_date, day) as order_duration_days
    from
        int_ecommerce_user_order_summary
)

select * from user_order_metrics
