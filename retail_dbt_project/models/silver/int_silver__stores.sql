{{
    config(
        materialized='incremental',
        unique_key='store_id'
    )
}}

SELECT
    store_id,
    INITCAP(TRIM(store_name)) AS store_name,
    INITCAP(TRIM(store_city)) AS store_city,
    INITCAP(TRIM(store_province)) AS store_province,
    INITCAP(TRIM(store_country)) AS store_country,
    store_created_timestamp,
    store_updated_timestamp,
    CAST(store_is_active AS boolean) AS store_is_active,
    CURRENT_TIMESTAMP() AS store_processed_at
FROM {{ ref('stg_bronze__stores') }}

{% if is_incremental() %}
    WHERE store_updated_timestamp > (SELECT COALESCE(MAX(store_updated_timestamp), '1990-01-01') FROM {{ this }})
{% endif %}