-- models/marts/user_order_metrics.sql

WITH int_ecommerce_user_order_summary as (
    SELECT * FROM {{ ref('int_ecommerce_user_order_summary') }}
),

user_order_metrics AS (

    SELECT
        user_id,
        total_orders,
        avg_items_per_order,
        first_order_date,
        last_order_date,
        -- Calculate the total items ordered by the user
        total_orders * avg_items_per_order AS total_items,
        -- Calculate the duration between the first and last order in days
        date_diff(last_order_date, first_order_date, day) AS order_duration_days
    FROM
        int_ecommerce_user_order_summary
)

SELECT * FROM user_order_metrics
