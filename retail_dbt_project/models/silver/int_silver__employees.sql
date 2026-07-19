{{
    config(
        materialized='incremental',
        unique_key='employee_id'
    )
}}

SELECT
    employee_id,
    store_id,
    INITCAP(TRIM(employee_first_name)) AS employee_first_name,
    INITCAP(TRIM(employee_last_name)) AS employee_last_name,
    LOWER(TRIM(employee_email)) AS employee_email,
    TRIM(job_title) AS job_title,
    CAST(salary AS DECIMAL(10, 2)) AS salary,
    employee_created_timestamp,
    employee_updated_timestamp,
    CAST(employee_is_active AS boolean) AS employee_is_active,
    CURRENT_TIMESTAMP() AS employee_processed_at
FROM {{ ref('stg_bronze__employees') }}

{% if is_incremental() %}
    WHERE employee_updated_timestamp > (SELECT COALESCE(MAX(employee_updated_timestamp), '1990-01-01') FROM {{ this }})
{% endif %}