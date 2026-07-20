SELECT
    dbt_scd_id AS employee_key,
    employee_id,
    (employee_first_name || ' ' || employee_last_name) AS employee_name,
    employee_email,
    job_title,
    salary,
    employee_created_timestamp,
    employee_is_active,
    dbt_valid_from,
    dbt_valid_to,
    CASE WHEN dbt_valid_to = '9999-12-31'::DATE THEN TRUE ELSE FALSE END AS is_current
FROM {{ ref('dim_employees_snapshot') }}