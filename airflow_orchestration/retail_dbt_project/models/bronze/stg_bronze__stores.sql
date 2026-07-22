SELECT
    store_id,
    store_name,
    city AS store_city,
    province AS store_province,
    country AS store_country,
    created_timestamp AS store_created_timestamp,
    updated_timestamp AS store_updated_timestamp,
    is_active AS store_is_active
FROM {{ source('retail_source', 'stores') }}