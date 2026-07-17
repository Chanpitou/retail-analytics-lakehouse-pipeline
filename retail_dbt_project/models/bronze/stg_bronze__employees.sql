SELECT
    employee_id,
    store_id,
    first_name AS employee_first_name,
    last_name AS employee_last_name,
    email AS employee_email,
    job_title,
    salary,
    created_timestamp AS employee_created_timestamp,
    updated_timestamp AS employee_updated_timestamp,
    is_active AS employee_is_active
FROM {{ source('retail_source', 'employees') }}