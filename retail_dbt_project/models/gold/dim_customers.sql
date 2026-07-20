SELECT
    dbt_scd_id AS customer_key,
    customer_id,
    (customer_first_name || ' ' || customer_last_name) AS customer_name,
    customer_email,
    customer_city,
    customer_province,
    customer_country,
    customer_created_timestamp,
    dbt_valid_from,
    dbt_valid_to,
    customer_is_active,
    CASE WHEN dbt_valid_to = '9999-12-31'::DATE THEN TRUE ELSE FALSE END AS is_current
FROM {{ ref('dim_customers_snapshot') }}