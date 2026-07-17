SELECT
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    line_amount,
    created_timestamp AS order_item_created_timestamp,
    updated_timestamp AS order_item_updated_timestamp,
    is_active AS order_item_is_active
FROM {{ source('retail_source', 'order_items') }}