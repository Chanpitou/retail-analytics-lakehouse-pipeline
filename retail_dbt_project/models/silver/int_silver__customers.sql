{{
    config(
        materialized='incremental',
        unique_key='customer_id'
    )
}}

SELECT
    customer_id,
    INITCAP(TRIM(customer_first_name)) AS customer_name,
    INITCAP(TRIM(customer_last_name)) AS customer_last_name,
    LOWER(TRIM(customer_email)) AS customer_email,
    customer_phone,
    INITCAP(TRIM(customer_city)) AS customer_city,
    INITCAP(TRIM(customer_province)) AS customer_province,
    INITCAP(TRIM(customer_country)) AS customer_country,
    customer_created_timestamp,
    customer_updated_timestamp,
    CAST(customer_is_active AS boolean) AS customer_is_active,
    CURRENT_TIMESTAMP() AS customer_processed_at
FROM {{ ref('stg_bronze__customers') }}

{% if is_incremental() %}
    WHERE customer_updated_timestamp > (SELECT COALESCE(MAX(customer_updated_timestamp), '1990-01-01') FROM {{ this }})
{% endif %}