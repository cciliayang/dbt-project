with products as(
	select
		product_id,
		name,
		category,
		retail_price,
		cost,
		department

	from {{ref('stg_ecommerce__products')}}
)

select
	product_id,
	name,
	category,
	retail_price,
	cost,
	department,

	-- aggregation function
	-- calculating product profit
	retail_price - cost as product_profit

from
	products