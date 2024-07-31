-- models/staging/stg_ecommerce__products.sql

WITH source AS (
	SELECT *

	FROM {{ source('thelook_ecommerce', 'products') }}
)

SELECT
	-- IDs
	id AS product_id,

	-- Other columns
	name,
	cost,
	retail_price,
	department,
	category

FROM source