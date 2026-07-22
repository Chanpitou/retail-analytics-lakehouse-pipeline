SELECT
    customer_id,
    first_name AS customer_first_name,
    last_name AS customer_last_name,
    email AS customer_email,
    phone AS customer_phone,
    city AS customer_city,
    province AS customer_province,
    country AS customer_country,
    created_timestamp AS customer_created_timestamp,
    updated_timestamp AS customer_updated_timestamp,
    is_active AS customer_is_active
FROM {{ source('retail_source', 'customers') }}