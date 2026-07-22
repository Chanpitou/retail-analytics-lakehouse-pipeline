SELECT
    order_item_id,
    quantity,
    unit_price,
    line_amount
FROM {{ ref('int_silver__order_items') }}
WHERE quantity < 0 OR unit_price < 0 OR line_amount < 0