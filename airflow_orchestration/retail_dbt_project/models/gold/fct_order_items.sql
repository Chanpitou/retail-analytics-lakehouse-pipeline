{{
  config(
    materialized='incremental',
    unique_key='order_item_id',
  )
}}

SELECT
    oi.order_item_id,
    dos.dbt_scd_id AS order_key,
    dcs.dbt_scd_id AS customer_key,
    des.dbt_scd_id AS employee_key,
    dps.dbt_scd_id AS product_key,
    dss.dbt_scd_id AS store,
    oi.quantity,
    oi.unit_price,
    oi.line_amount,
    CAST(oi.order_item_created_timestamp AS DATE) AS order_date,
    CAST(oi.order_item_updated_timestamp AS TIMESTAMP) AS order_updated,
    CURRENT_TIMESTAMP() AS fact_loaded_at
FROM {{ref('int_silver__order_items')}} oi
LEFT JOIN {{ref('dim_orders_snapshot')}} dos
    ON oi.order_id = dos.order_id
    AND oi.order_item_created_timestamp BETWEEN dos.dbt_valid_from
    AND COALESCE(dos.dbt_valid_to, CURRENT_TIMESTAMP())
LEFT JOIN {{ref('dim_products_snapshot')}} dps
    ON oi.product_id = dps.product_id
    AND oi.order_item_created_timestamp BETWEEN dps.dbt_valid_from
    AND COALESCE(dps.dbt_valid_to, CURRENT_TIMESTAMP())
LEFT JOIN {{ref('dim_employees_snapshot')}} des
    ON dos.store_id = des.store_id
    AND oi.order_item_created_timestamp BETWEEN des.dbt_valid_from
    AND COALESCE(des.dbt_valid_to, CURRENT_TIMESTAMP())
LEFT JOIN {{ref('dim_customers_snapshot')}} dcs
    ON dos.customer_id = dcs.customer_id
    AND oi.order_item_created_timestamp BETWEEN dcs.dbt_valid_from
    AND COALESCE(dcs.dbt_valid_to, CURRENT_TIMESTAMP())
LEFT JOIN {{ref('dim_stores_snapshot')}} dss
    ON dos.store_id = dss.store_id
    AND oi.order_item_created_timestamp BETWEEN dss.dbt_valid_from
    AND COALESCE(dss.dbt_valid_to, CURRENT_TIMESTAMP())

{% if is_incremental() %}
    WHERE oi.order_item_updated_timestamp > (SELECT COALESCE(MAX(order_updated), '1990-01-01') FROM {{ this }})
{% endif %}