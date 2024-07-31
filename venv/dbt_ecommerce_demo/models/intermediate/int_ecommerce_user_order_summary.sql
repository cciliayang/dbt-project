-- models/intermediate/int_user_order_summary.sql

WITH stg_ecommerce__orders as (
    SELECT * FROM {{ ref('stg_ecommerce__orders') }}
),

--perform aggregation functions from stg_ecommerce__orders
user_order_summary AS (
    SELECT
        user_id,
        count(order_id) AS total_orders,
        avg(num_items_ordered) AS avg_items_per_order,
        min(created_at) AS first_order_date,
        max(created_at) AS last_order_date
    FROM
        stg_ecommerce__orders
    GROUP BY
        user_id
)

SELECT * FROM user_order_summary
