SELECT
    dbt_scd_id AS order_key,
    order_id,
    payment_method,
    order_status,
    total_amount,
    order_created_timestamp,
    dbt_valid_from,
    dbt_valid_to,
    order_is_active,
    CASE WHEN dbt_valid_to = '9999-12-31'::DATE THEN TRUE ELSE FALSE END AS is_current
FROM {{ ref('dim_orders_snapshot') }}