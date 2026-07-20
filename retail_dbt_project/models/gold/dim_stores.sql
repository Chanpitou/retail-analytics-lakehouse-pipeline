SELECT
    dbt_scd_id AS store_key,
    store_id,
    store_name,
    store_city,
    store_province,
    store_country,
    store_created_timestamp,
    dbt_valid_from,
    dbt_valid_to,
    store_is_active,
    CASE WHEN dbt_valid_to = '9999-12-31'::DATE THEN TRUE ELSE FALSE END AS is_current
FROM {{ ref('dim_stores_snapshot') }}