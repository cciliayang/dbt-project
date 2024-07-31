-- models/intermediate/int_products_analysis.sql

WITH products AS(
	SELECT
		product_id,
		name,
		category,
		retail_price,
		cost,
		department

	FROM {{ref('stg_ecommerce__products')}}
)

SELECT
	product_id,
	name,
	category,
	retail_price,
	cost,
	department,

	-- aggregation function
	-- calculating product profit
	retail_price - cost AS product_profit

FROM
	products