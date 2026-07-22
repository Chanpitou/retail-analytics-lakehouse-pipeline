SELECT
    product_id,
    product_name,
    category,
    brand,
    price,
    created_timestamp AS product_created_timestamp,
    updated_timestamp AS product_updated_timestamp,
    is_active AS product_is_active
FROM {{ source('retail_source', 'products') }}