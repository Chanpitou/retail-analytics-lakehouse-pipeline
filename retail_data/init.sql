CREATE TABLE IF NOT EXISTS stores (
    store_id           INT PRIMARY KEY,
    store_name         TEXT,
    city                TEXT,
    province            TEXT,
    country             TEXT,
    created_timestamp   TIMESTAMP,
    updated_timestamp   TIMESTAMP,
    is_active           CHAR(1)
);

CREATE TABLE IF NOT EXISTS employees (
    employee_id         INT PRIMARY KEY,
    store_id             INT,
    first_name           TEXT,
    last_name            TEXT,
    email                TEXT,
    job_title            TEXT,
    salary               NUMERIC(12,2),
    created_timestamp    TIMESTAMP,
    updated_timestamp    TIMESTAMP,
    is_active            CHAR(1)
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id          INT PRIMARY KEY,
    first_name           TEXT,
    last_name             TEXT,
    email                TEXT,
    phone                TEXT,
    city                 TEXT,
    province             TEXT,
    country              TEXT,
    created_timestamp    TIMESTAMP,
    updated_timestamp    TIMESTAMP,
    is_active            CHAR(1)
);

CREATE TABLE IF NOT EXISTS products (
    product_id           INT PRIMARY KEY,
    product_name         TEXT,
    category             TEXT,
    brand                TEXT,
    price                NUMERIC(12,2),
    created_timestamp    TIMESTAMP,
    updated_timestamp    TIMESTAMP,
    is_active            CHAR(1)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id             INT PRIMARY KEY,
    customer_id          INT,
    store_id             INT,
    order_timestamp      TIMESTAMP,
    payment_method       TEXT,
    order_status         TEXT,
    total_amount         NUMERIC(12,2),
    created_timestamp    TIMESTAMP,
    updated_timestamp    TIMESTAMP,
    is_active            CHAR(1)
);

CREATE TABLE IF NOT EXISTS order_items (
    order_item_id        INT PRIMARY KEY,
    order_id              INT,
    product_id            INT,
    quantity               INT,
    unit_price             NUMERIC(12,2),
    line_amount            NUMERIC(12,2),
    created_timestamp      TIMESTAMP,
    updated_timestamp      TIMESTAMP,
    is_active               CHAR(1)
);

COPY stores       FROM '/data/stores.csv'       WITH (FORMAT csv, HEADER true);
COPY employees    FROM '/data/employees.csv'    WITH (FORMAT csv, HEADER true);
COPY customers    FROM '/data/customers.csv'    WITH (FORMAT csv, HEADER true);
COPY products     FROM '/data/products.csv'     WITH (FORMAT csv, HEADER true);
COPY orders       FROM '/data/orders.csv'       WITH (FORMAT csv, HEADER true);
COPY order_items  FROM '/data/order_items.csv'  WITH (FORMAT csv, HEADER true);
