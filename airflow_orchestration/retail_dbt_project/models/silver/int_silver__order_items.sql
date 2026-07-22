{{
    config(
        materialized='incremental',
        unique_key='order_item_id'
    )
}}

SELECT
    order_item_id,
    order_id,
    product_id,
    CAST(quantity AS INT) AS quantity,
    CAST(unit_price AS DECIMAL(10, 2)) AS unit_price,
    CAST(line_amount AS DECIMAL(10, 2)) AS line_amount,
    order_item_created_timestamp,
    order_item_updated_timestamp,
    CAST(order_item_is_active AS boolean) AS order_item_is_active,
    CURRENT_TIMESTAMP() AS order_item_processed_at
FROM {{ ref('stg_bronze__order_items') }}

{% if is_incremental() %}
    WHERE order_item_updated_timestamp > (SELECT COALESCE(MAX(order_item_updated_timestamp), '1990-01-01') FROM {{ this }})
{% endif %}