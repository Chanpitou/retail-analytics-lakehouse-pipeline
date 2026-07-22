SELECT
    order_id,
    total_amount
FROM {{ ref('int_silver__orders') }}
WHERE total_amount < 0