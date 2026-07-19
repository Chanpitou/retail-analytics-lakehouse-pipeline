{{
    config(
        materialized='incremental',
        unique_key='product_id'
    )
}}

SELECT
    product_id,
    INITCAP(TRIM(product_name)) AS product_name,
    INITCAP(TRIM(category)) AS category,
    INITCAP(TRIM(brand)) AS brand,
    CAST(price AS DECIMAL(10, 2)) AS price,
    product_created_timestamp,
    product_updated_timestamp,
    CAST(product_is_active AS boolean) AS product_is_active,
    CURRENT_TIMESTAMP() AS product_processed_at
FROM {{ ref('stg_bronze__products') }}

{% if is_incremental() %}
    WHERE product_updated_timestamp > (SELECT COALESCE(MAX(product_updated_timestamp), '1990-01-01') FROM {{ this }})
{% endif %}