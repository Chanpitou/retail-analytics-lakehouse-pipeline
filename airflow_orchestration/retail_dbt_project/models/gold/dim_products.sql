SELECT
    dbt_scd_id AS product_key,
    product_id,
    product_name,
    product_category,
    product_brand,
    unit_price,
    product_created_timestamp,
    dbt_valid_from,
    dbt_valid_to,
    product_is_active,
    CASE WHEN dbt_valid_to = '9999-12-31'::DATE THEN TRUE ELSE FALSE END AS is_current
FROM {{ ref('dim_products_snapshot') }}