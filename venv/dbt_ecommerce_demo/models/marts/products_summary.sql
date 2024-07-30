with product_analysis as(
	select
		product_id,
		category,
		department,
		product_profit

	from {{ref('int_products_analysis')}}
)

select
	department,
	category,
	avg(product_profit) as avg_profit,
	sum(product_profit) as total_profit,
	count(product_id) as num_of_products

from
	product_analysis
group by
	department, category