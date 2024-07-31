-- models/marts/products_summary.sql

WITH product_analysis AS(
	SELECT
		product_id,
		category,
		department,
		product_profit

	FROM {{ref('int_products_analysis')}}
)
-- aggregation function to perform different calculations
SELECT
	department,
	category,
	avg(product_profit) AS avg_profit,
	sum(product_profit) AS total_profit,
	count(product_id) AS num_of_products

FROM
	product_analysis
GROUP BY
	department, category