-- models/staging/stg_ecommerce__order_items.sql

WITH source AS (
	SELECT *

	FROM {{ source('thelook_ecommerce', 'order_items') }}
)

SELECT
	-- IDs
	id AS order_item_id,
	order_id,
	user_id,
	product_id,
	-- Other fields
	sale_price AS item_sale_price

FROM source
