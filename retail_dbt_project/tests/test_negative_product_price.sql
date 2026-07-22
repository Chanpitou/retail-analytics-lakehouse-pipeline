SELECT
    product_id,
    unit_price
FROM {{ ref('int_silver__products') }}
WHERE unit_price < 0
