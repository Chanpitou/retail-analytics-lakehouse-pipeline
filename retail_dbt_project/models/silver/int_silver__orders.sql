{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

SELECT
    order_id,
    customer_id,
    store_id,
    order_timestamp,
    payment_method,
    order_status,
    CAST(total_amount AS DECIMAL(10, 2)) AS total_amount,
    order_created_timestamp,
    order_updated_timestamp,
    CAST(order_is_active AS boolean) AS order_is_active,
    CURRENT_TIMESTAMP() AS order_processed_at
FROM {{ ref('stg_bronze__orders') }}

{% if is_incremental() %}
    WHERE order_updated_timestamp > (SELECT COALESCE(MAX(order_updated_timestamp), '1990-01-01') FROM {{ this }})
{% endif %}