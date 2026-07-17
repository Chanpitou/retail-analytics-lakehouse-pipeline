SELECT
    order_id,
    customer_id,
    store_id,
    order_timestamp,
    payment_method,
    order_status,
    total_amount,
    created_timestamp AS order_created_timestamp,
    updated_timestamp AS order_updated_timestamp,
    is_active AS order_is_active
FROM {{ source('retail_source', 'orders') }}